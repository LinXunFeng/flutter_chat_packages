/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 20:25:44
 */

import 'package:chat_bottom_container_example/feature/home/header/home_header.dart';
import 'package:chat_bottom_container_example/feature/home/logic/home_logic.dart';
import 'package:chat_bottom_container_example/feature/home/state/home_state.dart';
import 'package:chat_bottom_container_example/feature/home/widget/home_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomePage({
    super.key,
    required this.navigationShell,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with HomeLogicPutMixin<HomePage>, SingleTickerProviderStateMixin {
  HomeState get state => logic.state;

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    if (widget.navigationShell != oldWidget.navigationShell) {
      logic.state.navigationShell = widget.navigationShell;
      logic.update([
        HomeUpdateType.bottomNavBar,
      ]);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  HomeLogic initLogic() {
    return HomeLogic()..state.navigationShell = widget.navigationShell;
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<HomeLogic>(
      tag: logicTag,
      assignId: true,
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: widget.navigationShell,
          bottomNavigationBar: const HomeBottomNavBar(),
        );
      },
    );
  }
}
