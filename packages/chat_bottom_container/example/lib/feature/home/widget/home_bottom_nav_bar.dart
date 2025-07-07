/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 14:06:39
 */

import 'package:chat_bottom_container_example/feature/home/header/home_header.dart';
import 'package:chat_bottom_container_example/feature/home/logic/home_logic.dart';
import 'package:chat_bottom_container_example/feature/home/logic/home_logic_bottom_nav_bar.dart';
import 'package:chat_bottom_container_example/feature/home/state/home_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBottomNavBar extends StatefulWidget {
  const HomeBottomNavBar({super.key});

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar>
    with HomeLogicConsumerMixin<HomeBottomNavBar> {
  HomeState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      tag: logicTag,
      id: HomeUpdateType.bottomNavBar,
      builder: (_) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    return BottomNavigationBar(
      key: state.bottomNavigationBarKey,
      currentIndex: state.navigationShell.currentIndex,
      onTap: logic.handleBottomNavBarItemTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.animation),
          label: 'Animation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
