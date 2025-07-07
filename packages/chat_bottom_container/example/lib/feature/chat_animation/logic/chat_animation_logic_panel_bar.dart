/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:17:02
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';

extension ChatAnimationLogicPanelBar on ChatAnimationLogic {
  bool updateInputView({
    required bool isReadOnly,
  }) {
    if (state.readOnly != isReadOnly) {
      state.readOnly = isReadOnly;
      update([
        ChatAnimationUpdateType.inputView,
      ]);
      return true;
    }
    return false;
  }

  void handleInputViewOnPointerUp() {
    // Currently it may be emojiPanel.
    if (state.readOnly) {
      updatePanelType(ChatAnimationPanelType.keyboard);
    }
  }

  void handleEmojiBtnClick() {
    updatePanelType(
      ChatAnimationPanelType.emoji == state.currentPanelType
          ? ChatAnimationPanelType.keyboard
          : ChatAnimationPanelType.emoji,
    );
  }

  void handleToolBtnClick() {
    updatePanelType(
      ChatAnimationPanelType.tool == state.currentPanelType
          ? ChatAnimationPanelType.keyboard
          : ChatAnimationPanelType.tool,
    );
  }
}
