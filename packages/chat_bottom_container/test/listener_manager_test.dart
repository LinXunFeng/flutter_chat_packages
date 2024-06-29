/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-24 22:39:28
 */

import 'package:chat_bottom_container/listener_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test the times and order of listener callback calls',
      (tester) async {
    final manager = ChatBottomContainerListenerManager();
    List<String> recordCall = [];
    List<String> checkRecordCall = [];
    final page1Id = manager.register(
      (_) {
        recordCall.add('page1');
      },
    );
    expect(manager.pageIdMap.keys.length, 1);
    expect(manager.pageIdMap.keys.contains(page1Id), isTrue);

    final page2Id = manager.register(
      (_) {
        recordCall.add('page2');
      },
    );
    expect(manager.pageIdMap.keys.length, 2);
    expect(manager.pageIdMap.keys.contains(page2Id), isTrue);

    final page3Id = manager.register(
      (_) {
        recordCall.add('page3');
      },
    );
    expect(manager.pageIdMap.keys.length, 3);
    expect(manager.pageIdMap.keys.contains(page3Id), isTrue);

    final page4Id = manager.register(
      (_) {
        recordCall.add('page4');
      },
    );
    expect(manager.pageIdMap.keys.length, 4);
    expect(manager.pageIdMap.keys.contains(page4Id), isTrue);

    manager.flutterApi.keyboardHeight(1);
    checkRecordCall.add('page4');
    checkRecordCall.add('page3');
    checkRecordCall.add('page2');
    checkRecordCall.add('page1');
    expect(recordCall, checkRecordCall);

    manager.unregister(page4Id);
    expect(manager.pageIdMap.keys.length, 3);
    expect(manager.pageIdMap.keys.contains(page4Id), isFalse);
    expect(manager.pageIdMap.keys.contains(page3Id), isTrue);

    manager.flutterApi.keyboardHeight(1);
    checkRecordCall.add('page3');
    checkRecordCall.add('page2');
    checkRecordCall.add('page1');
    expect(recordCall, checkRecordCall);

    manager.unregister(page2Id);
    expect(manager.pageIdMap.keys.length, 2);
    expect(manager.pageIdMap.keys.contains(page2Id), isFalse);
    expect(manager.pageIdMap.keys.contains(page1Id), isTrue);

    manager.flutterApi.keyboardHeight(1);
    checkRecordCall.add('page3');
    checkRecordCall.add('page1');
    expect(recordCall, checkRecordCall);

    manager.unregister(page1Id);
    expect(manager.pageIdMap.keys.length, 1);
    expect(manager.pageIdMap.keys.contains(page1Id), isFalse);

    manager.flutterApi.keyboardHeight(1);
    checkRecordCall.add('page3');
    expect(recordCall, checkRecordCall);

    manager.unregister(page3Id);
    expect(manager.pageIdMap.keys, isEmpty);
  });
}
