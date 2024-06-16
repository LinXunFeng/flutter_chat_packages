import 'dart:math';

import 'package:chat_bottom_container/plugin/pigeon.g.dart';

typedef ChatKeyboardOnKeyboardHeightChange = Function(double);

class ChatBottomContainerListenerManager {
  List<String> pageIdStack = [];

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
        if (pageIdStack.isEmpty) return;
        pageIdMap[pageIdStack.last]?.call(height);
      },
    );
    FSAChatBottomContainerFlutterApi.setup(flutterApi);
  }

  String register(
    ChatKeyboardOnKeyboardHeightChange onKeyboardHeightChange,
  ) {
    final id = _uniqueId();
    pageIdStack.add(id);
    pageIdMap[id] = onKeyboardHeightChange;
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
