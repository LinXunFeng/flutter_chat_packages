/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:41:22
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ChatAnimationCubePanelContainer extends StatefulWidget {
  const ChatAnimationCubePanelContainer({super.key});

  @override
  State<ChatAnimationCubePanelContainer> createState() =>
      _ChatAnimationCubePanelContainerState();
}

class _ChatAnimationCubePanelContainerState
    extends State<ChatAnimationCubePanelContainer>
    with ChatAnimationLogicConsumerMixin<ChatAnimationCubePanelContainer> {
  ChatAnimationState get state => logic.state;

  ChatAnimationPanelType get currentPanelType => state.currentPanelType;

  Duration duration = const Duration(milliseconds: 300);

  bool useKeyboardHeight = true;

  int get currentIndex => state.panelTypes.indexOf(currentPanelType);

  PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatAnimationLogic>(
      tag: logicTag,
      id: ChatAnimationUpdateType.customPanelContainer,
      builder: (_) {
        if (!mounted) return const SizedBox.shrink();
        if (pageController == null) {
          pageController = PageController(
            initialPage: currentIndex,
          );
        } else {
          pageController?.animateToPage(
            currentIndex,
            duration: duration,
            curve: Curves.easeInOut,
          );
        }
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
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
          width: MediaQuery.sizeOf(context).width,
          height: state.controller.keyboardHeight,
          child: CubePageView(
            controller: pageController,
            children: state.panelTypes.map(
              (type) {
                return logic.buildPanelWidget(
                  type,
                  useKeyboardHeight: useKeyboardHeight,
                );
              },
            ).toList(),
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
}
