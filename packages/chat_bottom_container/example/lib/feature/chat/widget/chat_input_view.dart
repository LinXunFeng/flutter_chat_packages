/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 19:09:50
 */

import 'package:chat_bottom_container_example/feature/chat/header/chat_header.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic_panel_bar.dart';
import 'package:chat_bottom_container_example/feature/chat/state/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInputView extends StatefulWidget {
  const ChatInputView({super.key});

  @override
  State<ChatInputView> createState() => _ChatInputViewState();
}

class _ChatInputViewState extends State<ChatInputView>
    with ChatLogicConsumerMixin<ChatInputView> {
  ChatState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatLogic>(
      tag: logicTag,
      id: ChatUpdateType.inputView,
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
