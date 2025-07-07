/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:17:25
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_bar.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/chat_animation_emoji_panel.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/chat_animation_tool_panel.dart';
import 'package:flutter/material.dart';

extension ChatAnimationLogicPanelBar on ChatAnimationLogic {
  hidePanel() {
    if (state.inputFocusNode.hasFocus) {
      state.inputFocusNode.unfocus();
    }
    updateInputView(isReadOnly: false);
    if (ChatBottomPanelType.none == state.controller.currentPanelType) return;
    state.controller.updatePanelType(ChatBottomPanelType.none);
  }

  updatePanelType(ChatAnimationPanelType type) async {
    final isSwitchToKeyboard = ChatAnimationPanelType.keyboard == type;
    final isSwitchToEmojiPanel = ChatAnimationPanelType.emoji == type;
    bool isUpdated = false;
    switch (type) {
      case ChatAnimationPanelType.keyboard:
        updateInputView(isReadOnly: false);
        break;
      case ChatAnimationPanelType.emoji:
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
    ChatAnimationPanelType? data,
  ) {
    debugPrint('panelType: $panelType');
    switch (panelType) {
      case ChatBottomPanelType.none:
        state.currentPanelType = ChatAnimationPanelType.none;
        break;
      case ChatBottomPanelType.keyboard:
        state.currentPanelType = ChatAnimationPanelType.keyboard;
        break;
      case ChatBottomPanelType.other:
        if (data == null) return;
        switch (data) {
          case ChatAnimationPanelType.emoji:
            state.currentPanelType = ChatAnimationPanelType.emoji;
            break;
          case ChatAnimationPanelType.tool:
            state.currentPanelType = ChatAnimationPanelType.tool;
            break;
          default:
            state.currentPanelType = ChatAnimationPanelType.none;
            break;
        }
        break;
    }
  }

  Widget buildPanelWidget(
    ChatAnimationPanelType type, {
    bool useKeyboardHeight = true,
    bool isPlaceholder = false,
    Color? backgroundColor,
  }) {
    final panelController = state.controller;

    double? height = (useKeyboardHeight && panelController.keyboardHeight != 0)
        ? panelController.keyboardHeight
        : null;
    Widget resultWidget;
    switch (type) {
      case ChatAnimationPanelType.none:
        resultWidget = panelController.buildInPanel(ChatBottomPanelType.none) ??
            const SizedBox();
        if (backgroundColor != null) {
          resultWidget = Container(
            color: backgroundColor,
            child: resultWidget,
          );
        }
        break;
      case ChatAnimationPanelType.keyboard:
        resultWidget =
            panelController.buildInPanel(ChatBottomPanelType.keyboard) ??
                const SizedBox.shrink();
        if (backgroundColor != null) {
          resultWidget = Container(
            color: backgroundColor,
            child: resultWidget,
          );
        }
        break;
      case ChatAnimationPanelType.emoji:
        resultWidget = ChatAnimationEmojiPanel(
          height: height,
          isPlaceholder: isPlaceholder,
          backgroundColor: backgroundColor,
        );
        break;
      case ChatAnimationPanelType.tool:
        resultWidget = ChatAnimationToolPanel(
          height: height,
          isPlaceholder: isPlaceholder,
          backgroundColor: backgroundColor,
        );
        break;
    }
    if (isPlaceholder) {
      resultWidget = Visibility(
        visible: false,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: resultWidget,
      );
    }

    resultWidget = SizedBox(
      key: ValueKey('$type'),
      width: double.infinity,
      child: resultWidget,
    );

    return resultWidget;
  }
}
