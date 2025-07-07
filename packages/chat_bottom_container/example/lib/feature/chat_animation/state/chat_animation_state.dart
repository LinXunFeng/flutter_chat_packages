/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:03:14
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:flutter/material.dart';

class ChatAnimationState {
  ChatAnimationType animationType = ChatAnimationType.normal;

  final FocusNode inputFocusNode = FocusNode();

  final controller =
      ChatBottomPanelContainerController<ChatAnimationPanelType>();

  ChatAnimationPanelType currentPanelType = ChatAnimationPanelType.none;

  bool readOnly = false;

  List<ChatAnimationPanelType> panelTypes = [
    ChatAnimationPanelType.none,
    ChatAnimationPanelType.keyboard,
    ChatAnimationPanelType.emoji,
    ChatAnimationPanelType.tool,
  ];

  Widget? customPanelContainer;

  ChatAnimationAnimatedSwitcherPlusType currentSwitcherPlusType =
      ChatAnimationAnimatedSwitcherPlusType.flipX;

  List<ChatAnimationAnimatedSwitcherPlusType> switcherPlusTypes =
      ChatAnimationAnimatedSwitcherPlusType.values;

  ChatAnimationAnimatedSwitcherTransitionType currentSwitcherTransitionType =
      ChatAnimationAnimatedSwitcherTransitionType.flipX;

  List<ChatAnimationAnimatedSwitcherTransitionType> switcherTransitionTypes =
      ChatAnimationAnimatedSwitcherTransitionType.values;

  ChatAnimationTransitionedIndexedStackType currentIndexedStackTransitionType =
      ChatAnimationTransitionedIndexedStackType.scale;

  List<ChatAnimationTransitionedIndexedStackType> indexedStackTransitionTypes =
      ChatAnimationTransitionedIndexedStackType.values;


}
