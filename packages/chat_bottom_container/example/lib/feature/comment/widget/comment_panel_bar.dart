/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 21:58:25
 */

import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic_panel.dart';
import 'package:chat_bottom_container_example/feature/comment/state/comment_state.dart';
import 'package:flutter/material.dart';

class CommentPanelBar extends StatefulWidget {
  const CommentPanelBar({super.key});

  @override
  State<CommentPanelBar> createState() => _CommentPanelBarState();
}

class _CommentPanelBarState extends State<CommentPanelBar>
    with CommentLogicConsumerMixin<CommentPanelBar> {
  CommentState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Row(
      children: [
        const FlutterLogo(size: 30),
        const Spacer(),
        _buildEmojiBtn(),
        _buildToolBtn(),
      ],
    );
    resultWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      color: Colors.white,
      child: resultWidget,
    );
    return resultWidget;
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
