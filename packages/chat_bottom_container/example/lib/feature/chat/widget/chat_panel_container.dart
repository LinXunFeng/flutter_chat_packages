/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 18:58:33
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/feature/chat/header/chat_header.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat/page/chat_page.dart';
import 'package:chat_bottom_container_example/feature/chat/state/chat_state.dart';
import 'package:flutter/material.dart';

class ChatPanelContainer extends StatefulWidget {
  const ChatPanelContainer({super.key});

  @override
  State<ChatPanelContainer> createState() => _ChatPanelContainerState();
}

class _ChatPanelContainerState extends State<ChatPanelContainer>
    with ChatLogicConsumerMixin<ChatPanelContainer> {
  ChatState get state => logic.state;

  ChatPage get pageWidget => state.pageWidget;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return ChatBottomPanelContainer<ChatPanelType>(
      controller: state.controller,
      inputFocusNode: state.inputFocusNode,
      otherPanelWidget: (type) {
        if (type == null) return const SizedBox.shrink();
        switch (type) {
          case ChatPanelType.emoji:
            return _buildEmojiPickerPanel();
          case ChatPanelType.tool:
            return _buildToolPanel();
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: logic.onPanelTypeChange,
      changeKeyboardPanelHeight: pageWidget.changeKeyboardPanelHeight,
      panelBgColor: const Color(0xFFF5F5F5),
      safeAreaBottom: pageWidget.safeAreaBottom,
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
    final keyboardHeight = state.controller.keyboardHeight;
    if (keyboardHeight != 0) {
      if (pageWidget.changeKeyboardPanelHeight != null) {
        height = pageWidget.changeKeyboardPanelHeight!.call(keyboardHeight);
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
}
