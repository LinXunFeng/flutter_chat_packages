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
    List<String> checkRecordCall = [];
    final page1Id = manager.register(
      (_) {
        recordCall.add('page1');
      },
    );
    expect(manager.pageIdStack.length, 1);
    expect(manager.pageIdStack.last, page1Id);
    expect(manager.pageIdMap.keys.length, 1);
    expect(manager.pageIdMap.keys.contains(page1Id), isTrue);
    expect(manager.alwaysCallPageIdStack, isEmpty);

    final page2Id = manager.register(
      (_) {
        recordCall.add('page2');
      },
      callType: ChatBottomContainerListenCallType.alwaysAndStack,
    );
    expect(manager.pageIdStack.length, 2);
    expect(manager.pageIdStack.last, page2Id);
    expect(manager.pageIdMap.keys.length, 2);
    expect(manager.pageIdMap.keys.contains(page2Id), isTrue);
    expect(manager.alwaysCallPageIdStack.length, 1);
    expect(manager.alwaysCallPageIdStack.last, page2Id);

    final page3Id = manager.register(
      (_) {
        recordCall.add('page3');
      },
      callType: ChatBottomContainerListenCallType.alwaysAndUnstack,
    );
    expect(manager.pageIdStack.length, 2);
    expect(manager.pageIdStack.last, page2Id);
    expect(manager.pageIdMap.keys.length, 3);
    expect(manager.pageIdMap.keys.contains(page3Id), isTrue);
    expect(manager.alwaysCallPageIdStack.length, 2);
    expect(manager.alwaysCallPageIdStack.last, page3Id);

    final page4Id = manager.register(
      (_) {
        recordCall.add('page4');
      },
    );
    expect(manager.pageIdStack.length, 3);
    expect(manager.pageIdStack.last, page4Id);
    expect(manager.pageIdMap.keys.length, 4);
    expect(manager.pageIdMap.keys.contains(page4Id), isTrue);
    expect(manager.alwaysCallPageIdStack.length, 2);
    expect(manager.alwaysCallPageIdStack.last, page3Id);

    manager.flutterApi.keyboardHeight(1);
    checkRecordCall.add('page4');
    checkRecordCall.add('page3');
    checkRecordCall.add('page2');
    expect(recordCall, checkRecordCall);

    manager.unregister(page4Id);
    expect(manager.pageIdStack.length, 2);
    expect(manager.pageIdStack.last, page2Id);
    expect(manager.pageIdMap.keys.length, 3);
    expect(manager.pageIdMap.keys.contains(page4Id), isFalse);
    expect(manager.pageIdMap.keys.contains(page3Id), isTrue);
    expect(manager.alwaysCallPageIdStack.length, 2);

    manager.flutterApi.keyboardHeight(1);
    checkRecordCall.add('page2');
    checkRecordCall.add('page3');
    expect(recordCall, checkRecordCall);

    manager.unregister(page2Id);
    expect(manager.pageIdStack.length, 1);
    expect(manager.pageIdStack.last, page1Id);
    expect(manager.pageIdMap.keys.length, 2);
    expect(manager.pageIdMap.keys.contains(page2Id), isFalse);
    expect(manager.pageIdMap.keys.contains(page1Id), isTrue);
    expect(manager.alwaysCallPageIdStack.length, 1);

    manager.flutterApi.keyboardHeight(1);
    checkRecordCall.add('page1');
    checkRecordCall.add('page3');
    expect(recordCall, checkRecordCall);

    manager.unregister(page1Id);
    expect(manager.pageIdStack, isEmpty);
    expect(manager.pageIdMap.keys.length, 1);
    expect(manager.pageIdMap.keys.contains(page1Id), isFalse);
    expect(manager.alwaysCallPageIdStack.length, 1);

    manager.flutterApi.keyboardHeight(1);
    checkRecordCall.add('page3');
    expect(recordCall, checkRecordCall);

    manager.unregister(page3Id);
    expect(manager.pageIdMap.keys, isEmpty);
    expect(manager.alwaysCallPageIdStack, isEmpty);
  });
}
