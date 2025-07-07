/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 19:38:30
 */

import 'package:chat_bottom_container_example/common/route/route.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/home_animation/logic/home_animation_logic.dart';

extension HomeAnimationLogicListView on HomeAnimationLogic {
  void handleListItemTap(ChatAnimationType type) {
    state.currentAnimationType = type;

    NavigationService.push(
      MyPage.chatAnimation,
      extra: {
        'animationType': type,
      },
    );
  }
}
