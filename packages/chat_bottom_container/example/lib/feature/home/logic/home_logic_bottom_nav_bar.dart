/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 14:31:53
 */

import 'package:chat_bottom_container_example/feature/home/header/home_header.dart';
import 'package:chat_bottom_container_example/feature/home/logic/home_logic.dart';

extension HomeLogicBottomNavBar on HomeLogic {
  void handleBottomNavBarItemTap(int index) {
    state.navigationShell.goBranch(
      index,
      initialLocation: index == state.navigationShell.currentIndex,
    );
    update([
      HomeUpdateType.bottomNavBar,
    ]);
  }
}
