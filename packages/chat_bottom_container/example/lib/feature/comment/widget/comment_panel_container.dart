/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 21:49:49
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic_panel.dart';
import 'package:chat_bottom_container_example/feature/comment/state/comment_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentPanelContainer extends StatefulWidget {
  const CommentPanelContainer({super.key});

  @override
  State<CommentPanelContainer> createState() => _CommentPanelContainerState();
}

class _CommentPanelContainerState extends State<CommentPanelContainer>
    with CommentLogicConsumerMixin<CommentPanelContainer> {
  CommentState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentLogic>(
      tag: logicTag,
      id: CommentUpdateType.panelContainer,
      builder: (_) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return ChatBottomPanelContainer<CommentPanelType>(
      controller: state.controller,
      inputFocusNode: state.inputFocusNode,
      otherPanelWidget: (type) {
        if (type == null) return const SizedBox.shrink();
        switch (type) {
          case CommentPanelType.emoji:
            return _buildEmojiPickerPanel();
          case CommentPanelType.tool:
            return _buildToolPanel();
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: logic.onPanelTypeChange,
      panelBgColor: const Color(0xFFF5F5F5),
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
      height = keyboardHeight;
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
