/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-24 22:39:28
 */

import 'package:chat_bottom_container/listener_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('call times with ChatBottomContainerListenerCallType',
      (tester) async {
    final manager = ChatBottomContainerListenerManager();
    List<String> recordCall = [];
    final page1Id = manager.register(
      (_) {
        recordCall.add('page1');
      },
    );
    expect(manager.pageIdStack.length, 1);
    expect(manager.pageIdStack.last, page1Id);
    expect(manager.pageIdMap.keys.length, 1);
    expect(manager.pageIdMap.keys.last, page1Id);
    expect(manager.alwaysCallPageIdStack, isEmpty);

    final page2Id = manager.register(
      (_) {
        recordCall.add('page2');
      },
      callType: ChatBottomContainerListenCallType.always,
    );
    expect(manager.pageIdStack.length, 2);
    expect(manager.pageIdStack.last, page2Id);
    expect(manager.pageIdMap.keys.length, 2);
    expect(manager.pageIdMap.keys.last, page2Id);
    expect(manager.alwaysCallPageIdStack, isNotEmpty);
    expect(manager.alwaysCallPageIdStack.contains(page2Id), true);

    final page3Id = manager.register(
      (_) {
        recordCall.add('page3');
      },
    );
    expect(manager.pageIdStack.length, 3);
    expect(manager.pageIdStack.last, page3Id);
    expect(manager.pageIdMap.keys.length, 3);
    expect(manager.pageIdMap.keys.last, page3Id);
    expect(manager.alwaysCallPageIdStack.length, 1);

    manager.flutterApi.keyboardHeight(1);
    expect(recordCall, ['page2', 'page3']);

    manager.unregister(page3Id);
    expect(manager.pageIdStack.length, 2);
    expect(manager.pageIdStack.last, page2Id);
    expect(manager.pageIdMap.keys.length, 2);
    expect(manager.pageIdMap.keys.last, page2Id);
    expect(manager.alwaysCallPageIdStack.length, 1);

    manager.flutterApi.keyboardHeight(1);
    expect(recordCall, ['page2', 'page3', 'page2']);

    manager.unregister(page2Id);
    expect(manager.pageIdStack.length, 1);
    expect(manager.pageIdStack.last, page1Id);
    expect(manager.pageIdMap.keys.length, 1);
    expect(manager.pageIdMap.keys.last, page1Id);
    expect(manager.alwaysCallPageIdStack, isEmpty);

    manager.flutterApi.keyboardHeight(1);
    expect(recordCall, ['page2', 'page3', 'page2', 'page1']);
    manager.unregister(page1Id);
  });
}
