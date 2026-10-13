/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-16 11:10:28
 */

import 'dart:math';

import 'package:chat_bottom_container/plugin/pigeon.g.dart';
import 'package:flutter/services.dart';

typedef ChatKeyboardOnKeyboardHeightChange = Function(double);

class ChatBottomContainerListenerManager {
  Map<String, ChatKeyboardOnKeyboardHeightChange> pageIdMap = {};

  final hostApi = FSAChatBottomContainerHostApi();

  late FSAChatBottomContainerFlutterApiImp flutterApi;

  ChatBottomContainerListenerManager._internal() {
    _init();
  }

  static final ChatBottomContainerListenerManager _instance =
      ChatBottomContainerListenerManager._internal();

  factory ChatBottomContainerListenerManager() {
    return _instance;
  }

  _init() {
    flutterApi = FSAChatBottomContainerFlutterApiImp(
      onKeyboardHeight: (height) {
        // Full call, but only the input box that has gained focus can handle
        // the subsequent keyboard height change logic.
        // See [_ChatBottomPanelContainerState.onKeyboardHeightChange].
        pageIdMap.keys.toList().reversed.forEach((key) {
          pageIdMap[key]?.call(height);
        });
      },
    );
    FSAChatBottomContainerFlutterApi.setup(flutterApi);
    // 鸿蒙的整数高度可能被编码为 int，统一转为 double 后复用面板逻辑。
    const MethodChannel('chat_bottom_container/ohos')
        .setMethodCallHandler((call) async {
      if (call.method != 'keyboardHeight') return;
      final height = call.arguments;
      if (height is num && height.isFinite && height >= 0) {
        flutterApi.keyboardHeight(height.toDouble());
      }
    });
  }

  String register(
    ChatKeyboardOnKeyboardHeightChange onKeyboardHeightChange,
  ) {
    final id = _uniqueId();
    pageIdMap[id] = onKeyboardHeightChange;
    return id;
  }

  void unregister(String id) {
    pageIdMap.remove(id);
  }

  String _uniqueId() {
    int milliseconds = DateTime.now().millisecondsSinceEpoch;
    int randomValue = Random().nextInt(1000);
    return '$milliseconds$randomValue';
  }
}

class FSAChatBottomContainerFlutterApiImp
    extends FSAChatBottomContainerFlutterApi {
  final Function(double)? onKeyboardHeight;

  FSAChatBottomContainerFlutterApiImp({
    required this.onKeyboardHeight,
  });

  @override
  void keyboardHeight(double height) {
    onKeyboardHeight?.call(height);
  }
}
