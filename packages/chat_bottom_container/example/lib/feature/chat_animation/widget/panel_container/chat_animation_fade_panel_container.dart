/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:33:31
 */

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:flutter/material.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:get/get.dart';

class ChatAnimationFadePanelContainer extends StatefulWidget {
  const ChatAnimationFadePanelContainer({super.key});

  @override
  State<ChatAnimationFadePanelContainer> createState() =>
      _ChatAnimationFadePanelContainerState();
}

class _ChatAnimationFadePanelContainerState
    extends State<ChatAnimationFadePanelContainer>
    with ChatAnimationLogicConsumerMixin<ChatAnimationFadePanelContainer> {
  ChatAnimationState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatAnimationLogic>(
      tag: logicTag,
      id: ChatAnimationUpdateType.customPanelContainer,
      builder: (_) {
        if (!mounted) return const SizedBox.shrink();
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    Widget resultWidget = logic.buildPanelWidget(
      state.currentPanelType,
      useKeyboardHeight: false,
    );
    resultWidget = AnimatedSizeAndFade(
      fadeDuration: const Duration(milliseconds: 500),
      sizeDuration: const Duration(milliseconds: 300),
      child: resultWidget,
    );
    return resultWidget;
  }
}
