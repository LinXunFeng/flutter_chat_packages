/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:46:25
 */

import 'package:animated_switcher_transitions/animated_switcher_transitions.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAnimationSwitcherTransitionsPanelContainer extends StatefulWidget {
  const ChatAnimationSwitcherTransitionsPanelContainer({super.key});

  @override
  State<ChatAnimationSwitcherTransitionsPanelContainer> createState() =>
      _ChatAnimationSwitcherTransitionsPanelContainerState();
}

class _ChatAnimationSwitcherTransitionsPanelContainerState
    extends State<ChatAnimationSwitcherTransitionsPanelContainer>
    with
        ChatAnimationLogicConsumerMixin<
            ChatAnimationSwitcherTransitionsPanelContainer> {
  ChatAnimationState get state => logic.state;

  ChatAnimationPanelType get currentPanelType => state.currentPanelType;

  Duration duration = const Duration(milliseconds: 300);

  bool useKeyboardHeight = false;

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
    Widget resultWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        // Placeholder
        logic.buildPanelWidget(
          currentPanelType,
          useKeyboardHeight: useKeyboardHeight,
          isPlaceholder: true,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedSwitcher(
            duration: duration,
            switchInCurve: Curves.linear,
            switchOutCurve: Curves.linear,
            transitionBuilder: transitionBuilder(),
            layoutBuilder: AnimatedSwitcherLayouts.inOut,
            child: logic.buildPanelWidget(
              currentPanelType,
              useKeyboardHeight: useKeyboardHeight,
            ),
          ),
        ),
      ],
    );
    resultWidget = AnimatedSize(
      alignment: Alignment.topCenter,
      duration: duration,
      child: resultWidget,
    );
    return resultWidget;
  }

  Widget Function(
    Widget child,
    Animation<double> animation,
  ) transitionBuilder() {
    switch (state.currentSwitcherTransitionType) {
      case ChatAnimationAnimatedSwitcherTransitionType.fade:
        return AnimatedSwitcherTransitions.fade;
      case ChatAnimationAnimatedSwitcherTransitionType.flipX:
        return AnimatedSwitcherTransitions.flipX;
      case ChatAnimationAnimatedSwitcherTransitionType.flipY:
        return AnimatedSwitcherTransitions.flipY;
      case ChatAnimationAnimatedSwitcherTransitionType.shakeX:
        return AnimatedSwitcherTransitions.shakeX;
      case ChatAnimationAnimatedSwitcherTransitionType.shakeY:
        return AnimatedSwitcherTransitions.shakeY;
      case ChatAnimationAnimatedSwitcherTransitionType.zoomIn:
        return AnimatedSwitcherTransitions.zoomIn;
      case ChatAnimationAnimatedSwitcherTransitionType.zoomOut:
        return AnimatedSwitcherTransitions.zoomOut;
      case ChatAnimationAnimatedSwitcherTransitionType.slideTop:
        return AnimatedSwitcherTransitions.slideTop;
      case ChatAnimationAnimatedSwitcherTransitionType.slideBottom:
        return AnimatedSwitcherTransitions.slideBottom;
      case ChatAnimationAnimatedSwitcherTransitionType.slideLeft:
        return AnimatedSwitcherTransitions.slideLeft;
      case ChatAnimationAnimatedSwitcherTransitionType.slideRight:
        return AnimatedSwitcherTransitions.slideRight;
      case ChatAnimationAnimatedSwitcherTransitionType.slideTopLeft:
        return AnimatedSwitcherTransitions.slideTopLeft;
      case ChatAnimationAnimatedSwitcherTransitionType.slideTopRight:
        return AnimatedSwitcherTransitions.slideTopRight;
      case ChatAnimationAnimatedSwitcherTransitionType.slideBottomLeft:
        return AnimatedSwitcherTransitions.slideBottomLeft;
      case ChatAnimationAnimatedSwitcherTransitionType.slideBottomRight:
        return AnimatedSwitcherTransitions.slideBottomRight;
    }
  }
}
