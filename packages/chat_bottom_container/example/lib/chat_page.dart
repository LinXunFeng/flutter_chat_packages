/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-29 11:55:20
 */

import 'package:chat_bottom_container/panel_container.dart';
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
  });

  final double? safeAreaBottom;

  final bool showAppBar;

  final ChatKeyboardChangeKeyboardPanelHeight? changeKeyboardPanelHeight;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Color panelBgColor = const Color(0xFFF5F5F5);

  final FocusNode inputFocusNode = FocusNode();

  final controller = ChatBottomPanelContainerController<PanelType>();

  PanelType currentPanelType = PanelType.none;

  @override
  void dispose() {
    inputFocusNode.dispose();
    super.dispose();
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
    return Container(
      padding: EdgeInsets.zero,
      height: 300,
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
            child: TextField(
              focusNode: inputFocusNode,
            ),
          ),
          GestureDetector(
            child: const Icon(Icons.emoji_emotions_outlined, size: 30),
            onTap: () {
              updatePanelType(PanelType.emoji);
            },
          ),
          GestureDetector(
            child: const Icon(Icons.add, size: 30),
            onTap: () {
              updatePanelType(PanelType.tool);
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  updatePanelType(PanelType type) {
    controller.updatePanelType(
      type == currentPanelType
          ? ChatBottomPanelType.keyboard
          : ChatBottomPanelType.other,
      data: type,
    );
  }

  hidePanel() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
    }
    if (ChatBottomPanelType.none == controller.currentPanelType) return;
    controller.updatePanelType(ChatBottomPanelType.none);
  }
}
