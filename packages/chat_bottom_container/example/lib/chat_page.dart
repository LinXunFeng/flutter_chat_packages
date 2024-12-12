/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-29 11:55:20
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/main.dart';
import 'package:flutter/material.dart';

enum PanelType {
  none,
  keyboard,
  emoji,
  tool,
}

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    this.safeAreaBottom,
    this.showAppBar = true,
    this.changeKeyboardPanelHeight,
    this.onControllerCreated,
    this.keepPanel = false,
  });

  final double? safeAreaBottom;

  final bool showAppBar;

  final ChatKeyboardChangeKeyboardPanelHeight? changeKeyboardPanelHeight;

  final Function(ChatBottomPanelContainerController)? onControllerCreated;

  final bool keepPanel;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with RouteAware {
  Color panelBgColor = const Color(0xFFF5F5F5);

  final FocusNode inputFocusNode = FocusNode();

  final controller = ChatBottomPanelContainerController<PanelType>();

  PanelType currentPanelType = PanelType.none;

  bool readOnly = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void initState() {
    super.initState();

    widget.onControllerCreated?.call(controller);
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    App.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    if (!widget.keepPanel) {
      hidePanel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Chat Page'),
            )
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildList()),
          _buildInputView(),
          _buildPanelContainer(),
        ],
      ),
    );
  }

  Widget _buildList() {
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
        hidePanel();
      },
    );
    return resultWidget;
  }

  Widget _buildPanelContainer() {
    return ChatBottomPanelContainer<PanelType>(
      controller: controller,
      inputFocusNode: inputFocusNode,
      otherPanelWidget: (type) {
        if (type == null) return const SizedBox.shrink();
        switch (type) {
          case PanelType.emoji:
            return _buildEmojiPickerPanel();
          case PanelType.tool:
            return _buildToolPanel();
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: (panelType, data) {
        debugPrint('panelType: $panelType');
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
      changeKeyboardPanelHeight: widget.changeKeyboardPanelHeight,
      panelBgColor: panelBgColor,
      safeAreaBottom: widget.safeAreaBottom,
    );
  }

  Widget _buildToolPanel() {
    return Container(
      height: 450,
      color: Colors.red[50],
      child: const Center(
        child: Text('Tool Panel'),
      ),
    );
  }

  Widget _buildEmojiPickerPanel() {
    // If the keyboard height has been recorded, priority is given to setting
    // the height to the keyboard height.
    double height = 300;
    final keyboardHeight = controller.keyboardHeight;
    if (keyboardHeight != 0) {
      if (widget.changeKeyboardPanelHeight != null) {
        height = widget.changeKeyboardPanelHeight!.call(keyboardHeight);
      } else {
        height = keyboardHeight;
      }
    }

    return Container(
      padding: EdgeInsets.zero,
      height: height,
      color: Colors.blue[50],
      child: const Center(
        child: Text('Emoji Panel'),
      ),
    );
  }

  Widget _buildInputView() {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 15),
          Expanded(
            child: Listener(
              onPointerUp: (event) {
                // Currently it may be emojiPanel.
                if (readOnly) {
                  updatePanelType(PanelType.keyboard);
                }
              },
              child: TextField(
                focusNode: inputFocusNode,
                readOnly: readOnly,
                showCursor: true,
              ),
            ),
          ),
          GestureDetector(
            child: const Icon(Icons.emoji_emotions_outlined, size: 30),
            onTap: () {
              updatePanelType(
                PanelType.emoji == currentPanelType
                    ? PanelType.keyboard
                    : PanelType.emoji,
              );
            },
          ),
          GestureDetector(
            child: const Icon(Icons.add, size: 30),
            onTap: () {
              updatePanelType(
                PanelType.tool == currentPanelType
                    ? PanelType.keyboard
                    : PanelType.tool,
              );
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  updatePanelType(PanelType type) async {
    final isSwitchToKeyboard = PanelType.keyboard == type;
    final isSwitchToEmojiPanel = PanelType.emoji == type;
    bool isUpdated = false;
    switch (type) {
      case PanelType.keyboard:
        updateInputView(isReadOnly: false);
        break;
      case PanelType.emoji:
        isUpdated = updateInputView(isReadOnly: true);
        break;
      default:
        break;
    }

    updatePanelTypeFunc() {
      controller.updatePanelType(
        isSwitchToKeyboard
            ? ChatBottomPanelType.keyboard
            : ChatBottomPanelType.other,
        data: type,
        forceHandleFocus: isSwitchToEmojiPanel
            ? ChatBottomHandleFocus.requestFocus
            : ChatBottomHandleFocus.none,
      );
    }

    if (isUpdated) {
      // Waiting for the input view to update.
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        updatePanelTypeFunc();
      });
    } else {
      updatePanelTypeFunc();
    }
  }

  hidePanel() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
    }
    updateInputView(isReadOnly: false);
    if (ChatBottomPanelType.none == controller.currentPanelType) return;
    controller.updatePanelType(ChatBottomPanelType.none);
  }

  bool updateInputView({
    required bool isReadOnly,
  }) {
    if (readOnly != isReadOnly) {
      readOnly = isReadOnly;
      // You can just refresh the input view.
      setState(() {});
      return true;
    }
    return false;
  }
}
