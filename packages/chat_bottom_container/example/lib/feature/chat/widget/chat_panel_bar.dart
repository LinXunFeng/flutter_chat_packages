/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 18:56:10
 */

import 'package:chat_bottom_container_example/feature/chat/header/chat_header.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic_panel_bar.dart';
import 'package:chat_bottom_container_example/feature/chat/state/chat_state.dart';
import 'package:chat_bottom_container_example/feature/chat/widget/chat_input_view.dart';
import 'package:flutter/material.dart';

class ChatPanelBar extends StatefulWidget {
  const ChatPanelBar({super.key});

  @override
  State<ChatPanelBar> createState() => _ChatPanelBarState();
}

class _ChatPanelBarState extends State<ChatPanelBar>
    with ChatLogicConsumerMixin<ChatPanelBar> {
  ChatState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 15),
          const Expanded(child: ChatInputView()),
          _buildEmojiBtn(),
          _buildToolBtn(),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  Widget _buildEmojiBtn() {
    return GestureDetector(
      child: const Icon(Icons.emoji_emotions_outlined, size: 30),
      onTap: () {
        logic.handleEmojiBtnClick();
      },
    );
  }

  Widget _buildToolBtn() {
    return GestureDetector(
      child: const Icon(Icons.add, size: 30),
      onTap: () {
        logic.handleToolBtnClick();
      },
    );
  }
}
