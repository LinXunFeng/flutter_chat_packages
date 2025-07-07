/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:03:14
 */

import 'package:chat_bottom_container_example/common/route/route.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';

class ChatAnimationLogic extends GetxController {
  final ChatAnimationState state = ChatAnimationState();

  @override
  void onInit() async {
    super.onInit();

    state.animationType = NavigationService.getParam(
      'animationType',
      defaultValue: ChatAnimationType.normal,
    );
  }

  void showSnackBar({
    required String message,
  }) {
    ScaffoldMessenger.of(NavigationService.context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 500),
    );
    ScaffoldMessenger.of(NavigationService.context).showSnackBar(
      snackBar,
    );
  }
}
