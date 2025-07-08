/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-06 14:26:11
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:concentric_transition/page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAnimationConcentricPanelContainer extends StatefulWidget {
  const ChatAnimationConcentricPanelContainer({super.key});

  @override
  State<ChatAnimationConcentricPanelContainer> createState() =>
      _ChatAnimationConcentricPanelContainerState();
}

class _ChatAnimationConcentricPanelContainerState
    extends State<ChatAnimationConcentricPanelContainer>
    with
        ChatAnimationLogicConsumerMixin<ChatAnimationConcentricPanelContainer> {
  ChatAnimationState get state => logic.state;

  ChatAnimationPanelType get currentPanelType => state.currentPanelType;

  Duration duration = const Duration(milliseconds: 500);

  bool useKeyboardHeight = true;

  int get currentIndex => state.panelTypes.indexOf(currentPanelType);

  PageController? pageController;

  Color backgroundColor = Colors.transparent;

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
      clipBehavior: Clip.none,
      children: [
        // Placeholder
        logic.buildPanelWidget(
          currentPanelType,
          useKeyboardHeight: useKeyboardHeight,
          isPlaceholder: true,
          backgroundColor: backgroundColor,
        ),
        Positioned(
          top: 0,
          left: 0,
          width: MediaQuery.sizeOf(context).width,
          height: state.controller.keyboardHeight,
          child: ConcentricPageView(
            colors: const [
              Colors.green,
              Colors.red,
              Colors.blue,
              Colors.amber,
            ],
            pageController: pageController,
            radius: MediaQuery.sizeOf(context).width * 0.3,
            itemCount: state.panelTypes.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (int index) {
              Widget resultWidget = logic.buildPanelWidget(
                currentPanelType,
                useKeyboardHeight: useKeyboardHeight,
                backgroundColor: backgroundColor,
              );
              return resultWidget;
            },
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
