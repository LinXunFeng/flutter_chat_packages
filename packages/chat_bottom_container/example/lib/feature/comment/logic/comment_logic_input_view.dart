/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 22:37:11
 */

import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic_panel.dart';
import 'package:flutter/material.dart';

extension CommentLogicInputView on CommentLogic {
  bool updateInputView({
    required bool isReadOnly,
  }) {
    if (state.readOnly != isReadOnly) {
      state.readOnly = isReadOnly;
      update([
        if (state.inputFocusNode == state.titleFocusNode)
          CommentUpdateType.titleView,
        if (state.inputFocusNode == state.descFocusNode)
          CommentUpdateType.descView,
      ]);
      return true;
    }
    return false;
  }

  void handleInputViewOnPointerUp() {
    // Currently it may be emojiPanel.
    if (state.readOnly) {
      updatePanelType(CommentPanelType.keyboard);
    }
  }

  void handleInputViewOnPointerDown(FocusNode focusNode) async {
    if (state.inputFocusNode == focusNode) return;
    state.inputFocusNode = focusNode;
    update([
      CommentUpdateType.titleView,
      CommentUpdateType.descView,
      CommentUpdateType.panelContainer,
    ]);
  }
}
