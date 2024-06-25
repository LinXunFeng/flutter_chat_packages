/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-16 11:10:28
 */

import 'dart:math';

import 'package:chat_bottom_container/plugin/pigeon.g.dart';

enum ChatBottomContainerListenCallType {
  /// It will only be called when it is at the top of the stack.
  stackTop,

  /// It will be pushed onto the stack, but it will be called regardless of
  /// whether it is at the top of the stack.
  alwaysAndStack,

  /// It will not be pushed onto the stack, and it will always be called.
  alwaysAndUnstack,
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
        // Prioritize [pageIdStack]
        if (pageIdStack.isNotEmpty) {
          final activePageId = pageIdStack.last;
          pageIdMap[activePageId]?.call(height);
          recordMap[activePageId] = true;
        }

        for (var id in alwaysCallPageIdStack.reversed) {
          if (recordMap[id] == true) continue;
          pageIdMap[id]?.call(height);
          recordMap[id] = true;
        }
      },
    );
    FSAChatBottomContainerFlutterApi.setup(flutterApi);
  }

  String register(
    ChatKeyboardOnKeyboardHeightChange onKeyboardHeightChange, {
    ChatBottomContainerListenCallType callType =
        ChatBottomContainerListenCallType.stackTop,
  }) {
    final id = _uniqueId();
    pageIdMap[id] = onKeyboardHeightChange;
    switch (callType) {
      case ChatBottomContainerListenCallType.stackTop:
        pageIdStack.add(id);
        break;
      case ChatBottomContainerListenCallType.alwaysAndStack:
        pageIdStack.add(id);
        alwaysCallPageIdStack.add(id);
        break;
      case ChatBottomContainerListenCallType.alwaysAndUnstack:
        alwaysCallPageIdStack.add(id);
        break;
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
