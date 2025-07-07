/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:40:48
 */

import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAnimationSwitcherPlusPanelContainer extends StatefulWidget {
  const ChatAnimationSwitcherPlusPanelContainer({super.key});

  @override
  State<ChatAnimationSwitcherPlusPanelContainer> createState() =>
      _ChatAnimationSwitcherPlusPanelContainerState();
}

class _ChatAnimationSwitcherPlusPanelContainerState
    extends State<ChatAnimationSwitcherPlusPanelContainer>
    with
        ChatAnimationLogicConsumerMixin<
            ChatAnimationSwitcherPlusPanelContainer> {
  ChatAnimationState get state => logic.state;

  ChatAnimationPanelType get currentPanelType => state.currentPanelType;

  Duration duration = const Duration(milliseconds: 300);

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
    Widget resultWidget = logic.buildPanelWidget(currentPanelType);
    resultWidget = _buildAnimatedSwitcherPlus(
      child: resultWidget,
    );
    resultWidget = ClipRect(
      clipBehavior: Clip.hardEdge,
      child: resultWidget,
    );
    resultWidget = AnimatedSize(
      duration: duration,
      child: resultWidget,
    );
    return resultWidget;
  }

  Widget _buildAnimatedSwitcherPlus({
    required Widget child,
  }) {
    switch (state.currentSwitcherPlusType) {
      case ChatAnimationAnimatedSwitcherPlusType.flipX:
        return AnimatedSwitcherPlus.flipX(
          duration: duration,
          reverseDuration: duration,
          child: child,
        );
      case ChatAnimationAnimatedSwitcherPlusType.flipY:
        return AnimatedSwitcherPlus.flipY(
          duration: duration,
          reverseDuration: duration,
          child: child,
        );
      case ChatAnimationAnimatedSwitcherPlusType.translationLeft:
        return AnimatedSwitcherPlus.translationLeft(
          duration: duration,
          reverseDuration: duration,
          child: child,
        );
      case ChatAnimationAnimatedSwitcherPlusType.translationRight:
        return AnimatedSwitcherPlus.translationRight(
          duration: duration,
          reverseDuration: duration,
          child: child,
        );
      case ChatAnimationAnimatedSwitcherPlusType.translationTop:
        return AnimatedSwitcherPlus.translationTop(
          duration: duration,
          reverseDuration: duration,
          child: child,
        );
      case ChatAnimationAnimatedSwitcherPlusType.translationBottom:
        return AnimatedSwitcherPlus.translationBottom(
          duration: duration,
          reverseDuration: duration,
          child: child,
        );
      case ChatAnimationAnimatedSwitcherPlusType.zoomIn:
        return AnimatedSwitcherPlus.zoomIn(
          duration: duration,
          reverseDuration: duration,
          child: child,
        );
      case ChatAnimationAnimatedSwitcherPlusType.zoomOut:
        return AnimatedSwitcherPlus.zoomOut(
          duration: duration,
          reverseDuration: duration,
          child: child,
        );
    }
  }
}
