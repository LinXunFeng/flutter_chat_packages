/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-26 21:30:38
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container/constants.dart';
import 'package:chat_bottom_container/listener_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PanelType {
  none,
  keyboard,
  emoji,
  tool,
}

void main() {
  late SpyFocusNode inputFocusNode;
  late ChatBottomPanelContainerController<PanelType> controller;
  late PanelType currentPanelType;
  bool readOnly = false;
  int onPanelTypeChangeCallCount = 0;
  Function(void Function())? pageSetState;
  double? safeAreaBottom;

  setUp(() {
    inputFocusNode = SpyFocusNode();
    controller = ChatBottomPanelContainerController();
    currentPanelType = PanelType.none;
    readOnly = false;
    onPanelTypeChangeCallCount = 0;
    safeAreaBottom = null;
  });

  tearDown(() {
    inputFocusNode.unfocus();
    inputFocusNode.dispose();
    pageSetState = null;
  });

  updatePanelType(PanelType type) {
    controller.updatePanelType(
      PanelType.keyboard == type
          ? ChatBottomPanelType.keyboard
          : ChatBottomPanelType.other,
      data: type,
      forceHandleFocus: PanelType.emoji == type
          ? ChatBottomHandleFocus.requestFocus
          : ChatBottomHandleFocus.none,
    );
  }

  Widget buildList() {
    Widget resultWidget = ListView.builder(
      padding: EdgeInsets.zero,
      reverse: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item $index'),
        );
      },
    );
    resultWidget = Listener(
      child: resultWidget,
      onPointerDown: (event) {
        // Hide panel when touch ListView.
        if (inputFocusNode.hasFocus) {
          inputFocusNode.unfocus();
        }
        if (ChatBottomPanelType.none == controller.currentPanelType) return;
        controller.updatePanelType(ChatBottomPanelType.none);
      },
    );
    return resultWidget;
  }

  Widget buildToolPanel() {
    return Container(
      height: 450,
      color: Colors.red[50],
      child: const Center(
        child: Text('Tool Panel'),
      ),
    );
  }

  Widget buildEmojiPickerPanel() {
    return Container(
      padding: EdgeInsets.zero,
      height: 300,
      color: Colors.blue[50],
      child: const Center(
        child: Text('Emoji Panel'),
      ),
    );
  }

  Widget buildPanelContainer() {
    return ChatBottomPanelContainer<PanelType>(
      controller: controller,
      inputFocusNode: inputFocusNode,
      otherPanelWidget: (type) {
        if (type == null) return const SizedBox.shrink();
        switch (type) {
          case PanelType.emoji:
            return buildEmojiPickerPanel();
          case PanelType.tool:
            return buildToolPanel();
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: (panelType, data) {
        onPanelTypeChangeCallCount++;
        switch (panelType) {
          case ChatBottomPanelType.none:
            currentPanelType = PanelType.none;
            break;
          case ChatBottomPanelType.keyboard:
            currentPanelType = PanelType.keyboard;
            break;
          case ChatBottomPanelType.other:
            if (data == null) return;
            switch (data) {
              case PanelType.emoji:
                currentPanelType = PanelType.emoji;
                break;
              case PanelType.tool:
                currentPanelType = PanelType.tool;
                break;
              default:
                currentPanelType = PanelType.none;
                break;
            }
            break;
        }
      },
      safeAreaBottom: safeAreaBottom,
      // changeKeyboardPanelHeight: widget.changeKeyboardPanelHeight,
    );
  }

  Widget buildInputView() {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              focusNode: inputFocusNode,
              readOnly: readOnly,
              showCursor: true,
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget buildPage() {
    Widget resultWidget = StatefulBuilder(
      builder: (context, setState) {
        pageSetState = setState;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: const Text('Chat Page')),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: buildList()),
              buildInputView(),
              buildPanelContainer(),
            ],
          ),
        );
      },
    );
    resultWidget = MaterialApp(
      home: resultWidget,
    );
    return resultWidget;
  }

  switchToEmojiPanel() {
    inputFocusNode.requestFocus();
    readOnly = true;
    pageSetState?.call(() {});
    updatePanelType(PanelType.emoji);
  }

  switchToNone() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
    }
    if (readOnly) {
      readOnly = false;
      pageSetState?.call(() {});
    }
    if (ChatBottomPanelType.none != controller.currentPanelType) {
      controller.updatePanelType(ChatBottomPanelType.none);
    }
  }

  switchToToolPanel() {
    updatePanelType(PanelType.tool);
  }

  switchToKeyboard({
    required bool byUserClick,
  }) {
    readOnly = false;
    pageSetState?.call(() {});
    if (byUserClick) {
      inputFocusNode.requestFocus();
    } else {
      updatePanelType(PanelType.keyboard);
    }
  }

  testWidgets('test panel switching', (tester) async {
    int checkOnPanelTypeChangeCallCount = 0;

    await tester.pumpWidget(buildPage());
    expect(
      onPanelTypeChangeCallCount,
      checkOnPanelTypeChangeCallCount,
    );

    switchToKeyboard(byUserClick: true);
    checkOnPanelTypeChangeCallCount++;
    await tester.pumpAndSettle();
    expect(currentPanelType, PanelType.keyboard);
    expect(
      controller.currentPanelType,
      ChatBottomPanelType.keyboard,
    );
    expect(
      onPanelTypeChangeCallCount,
      checkOnPanelTypeChangeCallCount,
    );
    expect(inputFocusNode.hasFocus, isTrue);

    switchToNone();
    checkOnPanelTypeChangeCallCount++;
    await tester.pumpAndSettle();
    expect(currentPanelType, PanelType.none);
    expect(
      controller.currentPanelType,
      ChatBottomPanelType.none,
    );
    expect(
      onPanelTypeChangeCallCount,
      checkOnPanelTypeChangeCallCount,
    );
    expect(inputFocusNode.hasFocus, isFalse);

    switchToEmojiPanel();
    checkOnPanelTypeChangeCallCount++;
    await tester.pumpAndSettle();
    expect(currentPanelType, PanelType.emoji);
    expect(
      controller.currentPanelType,
      ChatBottomPanelType.other,
    );
    expect(
      onPanelTypeChangeCallCount,
      checkOnPanelTypeChangeCallCount,
    );
    expect(inputFocusNode.hasFocus, isTrue);
    expect(readOnly, isTrue);

    switchToKeyboard(byUserClick: false);
    checkOnPanelTypeChangeCallCount++;
    await tester.pumpAndSettle();
    expect(currentPanelType, PanelType.keyboard);
    expect(
      controller.currentPanelType,
      ChatBottomPanelType.keyboard,
    );
    expect(
      onPanelTypeChangeCallCount,
      checkOnPanelTypeChangeCallCount,
    );
    expect(inputFocusNode.hasFocus, isTrue);
    expect(readOnly, isFalse);

    switchToToolPanel();
    checkOnPanelTypeChangeCallCount++;
    await tester.pumpAndSettle();
    expect(currentPanelType, PanelType.tool);
    expect(
      controller.currentPanelType,
      ChatBottomPanelType.other,
    );
    expect(
      onPanelTypeChangeCallCount,
      checkOnPanelTypeChangeCallCount,
    );
    expect(inputFocusNode.hasFocus, isFalse);
    expect(readOnly, isFalse);
  });

  testWidgets('test safeAreaBottom', (tester) async {
    safeAreaBottom = null;
    await tester.pumpWidget(buildPage());
    expect(controller.safeAreaBottom, 0);

    // Dynamic update safeAreaBottom to 10
    safeAreaBottom = 10;
    pageSetState?.call(() {});
    await tester.pumpAndSettle();
    expect(controller.safeAreaBottom, 10);

    // Dynamic update safeAreaBottom to 20
    safeAreaBottom = 20;
    pageSetState?.call(() {});
    await tester.pumpAndSettle();
    expect(controller.safeAreaBottom, 20);

    // Dynamic update safeAreaBottom to null
    safeAreaBottom = null;
    pageSetState?.call(() {});
    await tester.pumpAndSettle();
    expect(controller.safeAreaBottom, 0);
  });

  testWidgets('test inputFocusNode switching', (tester) async {
    Widget chatWidget(FocusNode focusNode) {
      Widget resultWidget = Column(
        children: [
          TextField(
            focusNode: focusNode,
          ),
          ChatBottomPanelContainer<PanelType>(
            controller: controller,
            inputFocusNode: focusNode,
            otherPanelWidget: (type) => const SizedBox.shrink(),
          ),
        ],
      );
      resultWidget = Scaffold(
        resizeToAvoidBottomInset: false,
        body: resultWidget,
      );
      resultWidget = MaterialApp(
        home: resultWidget,
      );
      return resultWidget;
    }

    // Create initial inputFocusNode
    final initialFocusNode = FocusNode();

    // Build initial page
    await tester.pumpWidget(
      chatWidget(initialFocusNode),
    );

    // Verify initial state
    expect(controller.currentPanelType, ChatBottomPanelType.none);
    expect(initialFocusNode.hasFocus, isFalse);

    // Create new inputFocusNode
    final newFocusNode = FocusNode();

    // Update page with new inputFocusNode
    await tester.pumpWidget(
      chatWidget(newFocusNode),
    );

    // Verify new state
    expect(controller.currentPanelType, ChatBottomPanelType.none);
    expect(newFocusNode.hasFocus, isFalse);

    // Test focus change of new inputFocusNode
    newFocusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(controller.currentPanelType, ChatBottomPanelType.keyboard);
    expect(newFocusNode.hasFocus, isTrue);
    expect(initialFocusNode.hasFocus, isFalse);

    // Cleanup
    initialFocusNode.dispose();
    newFocusNode.dispose();
  });

  // Regression test for https://github.com/LinXunFeng/flutter_chat_packages/issues/23.
  testWidgets(
      'should remove listeners from inputFocusNode when ChatBottomPanelContainer is disposed',
      (tester) async {
    expect(inputFocusNode.hasListeners, isFalse);
    await tester.pumpWidget(buildPage());
    expect(inputFocusNode.hasListeners, isTrue);
    await tester.pumpWidget(const Placeholder());
    expect(inputFocusNode.hasListeners, isFalse);
  });

  testWidgets('test keyboard height orientation tracking', (tester) async {
    // Mock initial preference values
    SharedPreferences.setMockInitialValues({
      ChatBottomContainerPrefKey.keyboardHeightPortrait: 120.0,
      ChatBottomContainerPrefKey.keyboardHeightLandscape: 200.0,
    });

    // Set to portrait
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());

    // In portrait orientation, it should read keyboardHeightPortrait (120)
    expect(controller.keyboardHeight, 120.0);

    // Let's change orientation to landscape
    tester.view.physicalSize = const Size(800, 400);
    await tester.pumpAndSettle();

    // In landscape orientation, it should read keyboardHeightLandscape (200)
    expect(controller.keyboardHeight, 200.0);

    // Focus input so onKeyboardHeightChange callback can process keyboard height
    inputFocusNode.requestFocus();
    await tester.pumpAndSettle();

    // Trigger keyboard height change in landscape
    ChatBottomContainerListenerManager().flutterApi.keyboardHeight(250.0);
    await tester.pumpAndSettle();
    expect(controller.keyboardHeight, 250.0);

    // Change orientation back to portrait
    tester.view.physicalSize = const Size(400, 800);
    await tester.pumpAndSettle();

    // Should return portrait keyboard height (which is still 120)
    expect(controller.keyboardHeight, 120.0);

    // Trigger keyboard height change in portrait
    ChatBottomContainerListenerManager().flutterApi.keyboardHeight(150.0);
    await tester.pumpAndSettle();
    expect(controller.keyboardHeight, 150.0);

    // Verify stored values in SharedPreferences
    final pref = await SharedPreferences.getInstance();
    expect(
      pref.getDouble(ChatBottomContainerPrefKey.keyboardHeightPortrait),
      150.0,
    );
    expect(
      pref.getDouble(ChatBottomContainerPrefKey.keyboardHeightLandscape),
      250.0,
    );
    expect(
      pref.getDouble(ChatBottomContainerPrefKey.keyboardHeight),
      150.0,
    );
  });
}

class SpyFocusNode extends FocusNode {
  /// Override for test visibility only.
  @override
  bool get hasListeners => super.hasListeners;
}
