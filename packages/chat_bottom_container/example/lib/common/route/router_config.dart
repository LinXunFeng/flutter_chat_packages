/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 20:13:15
 */

import 'package:chat_bottom_container_example/common/route/navigation_service.dart';
import 'package:chat_bottom_container_example/feature/chat/page/chat_page.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/page/chat_animation_page.dart';
import 'package:chat_bottom_container_example/feature/home/page/home_page.dart';
import 'package:chat_bottom_container_example/feature/home_animation/page/home_animation_page.dart';
import 'package:chat_bottom_container_example/feature/home_chat/page/home_chat_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyPage {
  static const homeChat = '/home_chat';
  static const homeAnimation = '/home_animation';
  static const homeSetting = '/home_setting';
  static const chat = '/chat';
  static const chatAnimation = '/chat_animation';
}

class MyRoute {
  static final observer = RouteObserver<ModalRoute>();

  static final routerConfig = GoRouter(
    routes: routes,
    initialLocation: MyPage.homeChat,
    observers: [
      observer,
    ],
    navigatorKey: NavigationService.navigatorKey,
    debugLogDiagnostics: !kReleaseMode,
  );

  static final List<RouteBase> routes = [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomePage(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: MyPage.homeChat,
              builder: (context, state) => const HomeChatPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: MyPage.homeAnimation,
              builder: (context, state) => const HomeAnimationPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: MyPage.homeSetting,
              builder: (context, state) => Container(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: MyPage.chat,
      builder: (context, state) => const ChatPage(),
    ),
    GoRoute(
      path: MyPage.chatAnimation,
      builder: (context, state) => const ChatAnimationPage(),
    ),
  ];
}
