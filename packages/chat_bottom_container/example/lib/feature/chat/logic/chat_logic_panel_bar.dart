/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 18:51:07
 */

import 'package:chat_bottom_container_example/feature/chat/header/chat_header.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic_panel_container.dart';

extension ChatLogicPanelBar on ChatLogic {
  bool updateInputView({
    required bool isReadOnly,
  }) {
    if (state.readOnly != isReadOnly) {
      state.readOnly = isReadOnly;
      update([
        ChatUpdateType.inputView,
      ]);
      return true;
    }
    return false;
  }

  void handleInputViewOnPointerUp() {
    // Currently it may be emojiPanel.
    if (state.readOnly) {
      updatePanelType(ChatPanelType.keyboard);
    }
  }

  void handleEmojiBtnClick() {
    updatePanelType(
      ChatPanelType.emoji == state.currentPanelType
          ? ChatPanelType.keyboard
          : ChatPanelType.emoji,
    );
  }

  void handleToolBtnClick() {
    updatePanelType(
      ChatPanelType.tool == state.currentPanelType
          ? ChatPanelType.keyboard
          : ChatPanelType.tool,
    );
  }
}
