/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 16:37:32
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:flutter/material.dart';

class HomeAnimationState {
  late BuildContext context;

  ChatAnimationType currentAnimationType = ChatAnimationType.normal;

  List<ChatAnimationType> animationTypes = ChatAnimationType.values;
}
