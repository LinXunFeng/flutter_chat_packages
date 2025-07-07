/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 22:37:49
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic_input_view.dart';
import 'package:flutter/material.dart';

extension CommentLogicPanel on CommentLogic {
  void hidePanel() {
    if (state.inputFocusNode.hasFocus) {
      state.inputFocusNode.unfocus();
    }
    updateInputView(isReadOnly: false);
    if (ChatBottomPanelType.none == state.controller.currentPanelType) return;
    state.controller.updatePanelType(ChatBottomPanelType.none);
  }

  void updatePanelType(CommentPanelType type) async {
    final isSwitchToKeyboard = CommentPanelType.keyboard == type;
    final isSwitchToEmojiPanel = CommentPanelType.emoji == type;
    bool isUpdated = false;
    switch (type) {
      case CommentPanelType.keyboard:
        updateInputView(isReadOnly: false);
        break;
      case CommentPanelType.emoji:
        isUpdated = updateInputView(isReadOnly: true);
        break;
      default:
        break;
    }

    void updatePanelTypeFunc() {
      state.controller.updatePanelType(
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

  void handleEmojiBtnClick() {
    updatePanelType(
      CommentPanelType.emoji == state.currentPanelType
          ? CommentPanelType.keyboard
          : CommentPanelType.emoji,
    );
  }

  void handleToolBtnClick() {
    updatePanelType(
      CommentPanelType.tool == state.currentPanelType
          ? CommentPanelType.keyboard
          : CommentPanelType.tool,
    );
  }

  void onPanelTypeChange(
    ChatBottomPanelType panelType,
    CommentPanelType? data,
  ) {
    debugPrint('panelType: $panelType');
    switch (panelType) {
      case ChatBottomPanelType.none:
        state.currentPanelType = CommentPanelType.none;
        break;
      case ChatBottomPanelType.keyboard:
        state.currentPanelType = CommentPanelType.keyboard;
        break;
      case ChatBottomPanelType.other:
        if (data == null) return;
        switch (data) {
          case CommentPanelType.emoji:
            state.currentPanelType = CommentPanelType.emoji;
            break;
          case CommentPanelType.tool:
            state.currentPanelType = CommentPanelType.tool;
            break;
          default:
            state.currentPanelType = CommentPanelType.none;
            break;
        }
        break;
    }
  }
}
