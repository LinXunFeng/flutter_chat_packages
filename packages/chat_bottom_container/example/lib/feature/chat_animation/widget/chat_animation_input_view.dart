/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:11:41
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_bar.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAnimationInputView extends StatefulWidget {
  const ChatAnimationInputView({super.key});

  @override
  State<ChatAnimationInputView> createState() => _ChatAnimationInputViewState();
}

class _ChatAnimationInputViewState extends State<ChatAnimationInputView>
    with ChatAnimationLogicConsumerMixin<ChatAnimationInputView> {
  ChatAnimationState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatAnimationLogic>(
      tag: logicTag,
      id: ChatAnimationUpdateType.inputView,
      builder: (_) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    Widget resultWidget = TextField(
      focusNode: state.inputFocusNode,
      readOnly: state.readOnly,
      showCursor: true,
    );
    resultWidget = Listener(
      onPointerUp: (event) {
        logic.handleInputViewOnPointerUp();
      },
      child: resultWidget,
    );
    return resultWidget;
  }
}
