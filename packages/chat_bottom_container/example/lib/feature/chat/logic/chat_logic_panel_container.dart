/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 20:28:08
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/feature/chat/header/chat_header.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic_panel_bar.dart';
import 'package:flutter/material.dart';

extension ChatLogicPanelContainer on ChatLogic {
  hidePanel() {
    if (state.inputFocusNode.hasFocus) {
      state.inputFocusNode.unfocus();
    }
    updateInputView(isReadOnly: false);
    if (ChatBottomPanelType.none == state.controller.currentPanelType) return;
    state.controller.updatePanelType(ChatBottomPanelType.none);
  }

  updatePanelType(ChatPanelType type) async {
    final isSwitchToKeyboard = ChatPanelType.keyboard == type;
    final isSwitchToEmojiPanel = ChatPanelType.emoji == type;
    bool isUpdated = false;
    switch (type) {
      case ChatPanelType.keyboard:
        updateInputView(isReadOnly: false);
        break;
      case ChatPanelType.emoji:
        isUpdated = updateInputView(isReadOnly: true);
        break;
      default:
        break;
    }

    updatePanelTypeFunc() {
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

  void onPanelTypeChange(
    ChatBottomPanelType panelType,
    ChatPanelType? data,
  ) {
    debugPrint('panelType: $panelType');
    switch (panelType) {
      case ChatBottomPanelType.none:
        state.currentPanelType = ChatPanelType.none;
        break;
      case ChatBottomPanelType.keyboard:
        state.currentPanelType = ChatPanelType.keyboard;
        break;
      case ChatBottomPanelType.other:
        if (data == null) return;
        switch (data) {
          case ChatPanelType.emoji:
            state.currentPanelType = ChatPanelType.emoji;
            break;
          case ChatPanelType.tool:
            state.currentPanelType = ChatPanelType.tool;
            break;
          default:
            state.currentPanelType = ChatPanelType.none;
            break;
        }
        break;
    }
  }
}
