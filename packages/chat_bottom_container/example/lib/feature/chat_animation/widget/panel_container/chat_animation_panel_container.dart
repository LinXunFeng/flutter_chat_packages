/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:42:35
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/panel_container/chat_animation_concentric_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/panel_container/chat_animation_cube_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/panel_container/chat_animation_fade_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/panel_container/chat_animation_switcher_transitions_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/panel_container/chat_animation_transitioned_indexed_stack_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/panel_container/chat_animation_switcher_plus_panel_container.dart';
import 'package:flutter/material.dart';

class ChatAnimationPanelContainer extends StatefulWidget {
  const ChatAnimationPanelContainer({super.key});

  @override
  State<ChatAnimationPanelContainer> createState() =>
      _ChatAnimationPanelContainerState();
}

class _ChatAnimationPanelContainerState
    extends State<ChatAnimationPanelContainer>
    with ChatAnimationLogicConsumerMixin<ChatAnimationPanelContainer> {
  ChatAnimationState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return ChatBottomPanelContainer<ChatAnimationPanelType>(
      controller: state.controller,
      inputFocusNode: state.inputFocusNode,
      onPanelTypeChange: logic.onPanelTypeChange,
      panelBgColor: const Color(0xFFF5F5F5),
      otherPanelWidget: ChatAnimationType.normal != state.animationType
          ? null
          : (type) {
              return type == null
                  ? const SizedBox.shrink()
                  : logic.buildPanelWidget(type);
            },
      customPanelContainer: ChatAnimationType.normal == state.animationType
          ? null
          : (panelType, data) {
              if (!mounted) return const SizedBox.shrink();
              Widget? container = state.customPanelContainer;
              if (container != null) {
                logic.update([
                  ChatAnimationUpdateType.customPanelContainer,
                ]);
                return container;
              }
              switch (state.animationType) {
                case ChatAnimationType.fade:
                  container = const ChatAnimationFadePanelContainer();
                  break;
                case ChatAnimationType.animatedSwitcherPlus:
                  container = const ChatAnimationSwitcherPlusPanelContainer();
                  break;
                case ChatAnimationType.animatedSwitcherTransitions:
                  container =
                      const ChatAnimationSwitcherTransitionsPanelContainer();
                  break;
                case ChatAnimationType.transitionedIndexedStack:
                  container =
                      const ChatAnimationTransitionedIndexedStackPanelContainer();
                  break;
                case ChatAnimationType.cube:
                  container = const ChatAnimationCubePanelContainer();
                  break;
                case ChatAnimationType.concentric:
                  container = const ChatAnimationConcentricPanelContainer();
                  break;
                default:
                  container = const SizedBox.shrink();
              }
              container = ClipRRect(
                clipBehavior: Clip.hardEdge,
                child: container,
              );
              state.customPanelContainer = container;
              return container;
            },
    );
  }
}
