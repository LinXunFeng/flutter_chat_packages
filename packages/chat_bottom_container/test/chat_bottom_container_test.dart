/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-26 21:30:38
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum PanelType {
  none,
  keyboard,
  emoji,
  tool,
}

void main() {
  late FocusNode inputFocusNode;
  late ChatBottomPanelContainerController<PanelType> controller;
  late PanelType currentPanelType;
  bool readOnly = false;
  int onPanelTypeChangeCallCount = 0;
  Function(void Function())? pageSetState;
  double? safeAreaBottom;

  setUp(() {
    inputFocusNode = FocusNode();
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

    await tester.pumpWidget(const Placeholder());

    safeAreaBottom = 10;
    await tester.pumpWidget(buildPage());
    expect(controller.safeAreaBottom, 10);
  });
}
