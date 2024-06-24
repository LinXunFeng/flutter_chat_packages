/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-16 11:10:28
 */

import 'dart:math';

import 'package:chat_bottom_container/plugin/pigeon.g.dart';

enum ChatBottomContainerListenCallType {
  active,
  always,
}

typedef ChatKeyboardOnKeyboardHeightChange = Function(double);

class ChatBottomContainerListenerManager {
  List<String> pageIdStack = [];

  Map<String, ChatKeyboardOnKeyboardHeightChange> pageIdMap = {};

  List<String> alwaysCallPageIdStack = [];

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
        Map<String, bool> recordMap = {};
        for (var id in alwaysCallPageIdStack.reversed) {
          pageIdMap[id]?.call(height);
          recordMap[id] = true;
        }
        if (pageIdStack.isEmpty) return;
        final activePageId = pageIdStack.last;
        if (recordMap[activePageId] == null) {
          pageIdMap[activePageId]?.call(height);
        }
      },
    );
    FSAChatBottomContainerFlutterApi.setup(flutterApi);
  }

  String register(
    ChatKeyboardOnKeyboardHeightChange onKeyboardHeightChange, {
    ChatBottomContainerListenCallType callType =
        ChatBottomContainerListenCallType.active,
  }) {
    final id = _uniqueId();
    pageIdStack.add(id);
    pageIdMap[id] = onKeyboardHeightChange;
    if (callType == ChatBottomContainerListenCallType.always) {
      alwaysCallPageIdStack.add(id);
    }
    return id;
  }

  void unregister(String id) {
    if (pageIdStack.isNotEmpty) {
      if (pageIdStack.last == id) {
        pageIdStack.removeLast();
      } else {
        final index = pageIdStack.lastIndexOf(id);
        if (index != -1) {
          pageIdStack.removeAt(index);
        }
      }
    }
    pageIdMap.remove(id);
    alwaysCallPageIdStack.remove(id);
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
