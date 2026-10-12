import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container/listener_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> sendOhosHeight(WidgetTester tester, Object height) async {
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'chat_bottom_container/ohos',
    const StandardMethodCodec()
        .encodeMethodCall(MethodCall('keyboardHeight', height)),
    (_) {},
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('鸿蒙通道接收整数、浮点数与隐藏事件，忽略无效高度', (tester) async {
    final manager = ChatBottomContainerListenerManager();
    final heights = <double>[];
    final id = manager.register(heights.add);
    addTearDown(() => manager.unregister(id));
    for (final value in <Object>[320, 321.5, 0, -1, double.nan, '320']) {
      await sendOhosHeight(tester, value);
    }
    expect(heights, [320.0, 321.5, 0.0]);
    manager.unregister(id);
    await sendOhosHeight(tester, 400);
    expect(heights, hasLength(3));
  });

  testWidgets('首次面板切回键盘不塌陷，鸿蒙收起事件不关闭已切换的面板', (tester) async {
    final focus = FocusNode();
    final controller = ChatBottomPanelContainerController<String>();
    addTearDown(focus.dispose);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        TextField(focusNode: focus),
        ChatBottomPanelContainer<String>(
          key: const ValueKey('面板'),
          controller: controller,
          inputFocusNode: focus,
          safeAreaBottom: 0,
          defaultKeyboardHeight: 300,
          otherPanelWidget: (_) => const SizedBox(height: 300),
        ),
      ]),
    )));
    controller.updatePanelType(ChatBottomPanelType.other, data: '表情');
    await tester.pumpAndSettle();
    controller.updatePanelType(ChatBottomPanelType.keyboard);
    await tester.pump();
    controller.updatePanelType(ChatBottomPanelType.keyboard);
    await tester.pump();
    expect(tester.getSize(find.byKey(const ValueKey('面板'))).height, 300);
    await sendOhosHeight(tester, 360);
    await tester.pumpAndSettle();
    expect(controller.keyboardHeight, 360);
    controller.updatePanelType(ChatBottomPanelType.other, data: '更多');
    await tester.pumpAndSettle();
    await sendOhosHeight(tester, 0);
    await tester.pumpAndSettle();
    expect(controller.currentPanelType, ChatBottomPanelType.other);
    expect(controller.data, '更多');
    await tester.pumpWidget(const SizedBox());
    await sendOhosHeight(tester, 0);
    expect(tester.takeException(), isNull);
  });
}
