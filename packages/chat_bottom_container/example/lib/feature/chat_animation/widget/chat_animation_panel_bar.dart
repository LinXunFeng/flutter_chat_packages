/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:12:09
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_bar.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/chat_animation_input_view.dart';
import 'package:flutter/material.dart';

class ChatAnimationPanelBar extends StatefulWidget {
  const ChatAnimationPanelBar({super.key});

  @override
  State<ChatAnimationPanelBar> createState() => _ChatAnimationPanelBarState();
}

class _ChatAnimationPanelBarState extends State<ChatAnimationPanelBar>
    with ChatAnimationLogicConsumerMixin<ChatAnimationPanelBar> {
  ChatAnimationState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 15),
          const Expanded(child: ChatAnimationInputView()),
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
