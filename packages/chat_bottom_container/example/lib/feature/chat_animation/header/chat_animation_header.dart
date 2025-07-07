/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:03:14
 */

import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:flutter/material.dart';
import 'package:getx_helper/getx_helper.dart';

typedef ChatAnimationLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<ChatAnimationLogic, W>;

typedef ChatAnimationLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<ChatAnimationLogic, W>;

enum ChatAnimationPanelType {
  none,
  keyboard,
  emoji,
  tool,
}

enum ChatAnimationUpdateType {
  inputView,
  customPanelContainer,
}

enum ChatAnimationType {
  normal,
  fade,
  animatedSwitcherPlus,
  animatedSwitcherTransitions,
  transitionedIndexedStack,
  cube,
  concentric,
}

/// animated_switcher_plus
enum ChatAnimationAnimatedSwitcherPlusType {
  flipX,
  flipY,
  translationLeft,
  translationRight,
  translationTop,
  translationBottom,
  zoomIn,
  zoomOut,
}

/// animated_switcher_transitions
enum ChatAnimationAnimatedSwitcherTransitionType {
  fade,
  flipX,
  flipY,
  shakeX,
  shakeY,
  zoomIn,
  zoomOut,
  slideTop,
  slideBottom,
  slideLeft,
  slideRight,
  slideTopLeft,
  slideTopRight,
  slideBottomLeft,
  slideBottomRight,
}

/// transitioned_indexed_stack
enum ChatAnimationTransitionedIndexedStackType {
  fade,
  scale,
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  sizeFactor,
  rotation,
  diagonalTopLeft,
  diagonalTopRight,
  diagonalBottomLeft,
  diagonalBottomRight,
  shake,
}
