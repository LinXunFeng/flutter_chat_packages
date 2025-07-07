/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:41:11
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

class ChatAnimationTransitionedIndexedStackPanelContainer
    extends StatefulWidget {
  const ChatAnimationTransitionedIndexedStackPanelContainer({super.key});

  @override
  State<ChatAnimationTransitionedIndexedStackPanelContainer> createState() =>
      _ChatAnimationTransitionedIndexedStackPanelContainerState();
}

class _ChatAnimationTransitionedIndexedStackPanelContainerState
    extends State<ChatAnimationTransitionedIndexedStackPanelContainer>
    with
        ChatAnimationLogicConsumerMixin<
            ChatAnimationTransitionedIndexedStackPanelContainer> {
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
    final index = state.panelTypes.indexOf(currentPanelType);
    Widget resultWidget = Stack(
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
          child: _buildTransitionedIndexedStack(
            index: index,
            children: state.panelTypes.map((type) {
              return logic.buildPanelWidget(
                type,
                useKeyboardHeight: useKeyboardHeight,
              );
            }).toList(),
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

  Widget _buildTransitionedIndexedStack({
    required List<Widget> children,
    required int index,
  }) {
    switch (state.currentIndexedStackTransitionType) {
      case ChatAnimationTransitionedIndexedStackType.fade:
        return FadeIndexedStack(
          beginOpacity: 0.0,
          endOpacity: 1.0,
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.scale:
        return ScaleIndexedStack(
          beginScale: 0.0,
          endScale: 1.0,
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.slideUp:
        return SlideIndexedStack(
          beginSlideOffset: const Offset(0, 1),
          endSlideOffset: const Offset(0.0, 0.0),
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.slideDown:
        return SlideIndexedStack(
          beginSlideOffset: const Offset(0, -1),
          endSlideOffset: const Offset(0.0, 0.0),
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.slideLeft:
        return SlideIndexedStack(
          beginSlideOffset: const Offset(1, 0),
          endSlideOffset: const Offset(0.0, 0.0),
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.slideRight:
        return SlideIndexedStack(
          beginSlideOffset: const Offset(-1, 0),
          endSlideOffset: const Offset(0.0, 0.0),
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.sizeFactor:
        return SizeFactorIndexedStack(
          beginSizeFactor: 0.0,
          endSizeFactor: 1.0,
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.rotation:
        return RotationIndexedStack(
          beginTurn: 0.0,
          endTurn: 1.0,
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.diagonalTopLeft:
        return DiagonalIndexedStack.topLeft(
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.diagonalTopRight:
        return DiagonalIndexedStack.topRight(
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.diagonalBottomLeft:
        return DiagonalIndexedStack.bottomLeft(
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.diagonalBottomRight:
        return DiagonalIndexedStack.bottomRight(
          curve: Curves.easeInOut,
          duration: duration,
          index: index,
          children: children,
        );
      case ChatAnimationTransitionedIndexedStackType.shake:
        return ShakeIndexedStack(
          shakesCount: 100,
          shakeFrequency: 0.04,
          curve: Curves.slowMiddle,
          duration: duration,
          index: index,
          children: children,
        );
    }
  }
}
