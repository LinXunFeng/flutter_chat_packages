/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 16:37:32
 */

import 'package:chat_bottom_container_example/feature/home_animation/widget/home_animation_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_bottom_container_example/feature/home_animation/logic/home_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/home_animation/header/home_animation_header.dart';

class HomeAnimationPage extends StatefulWidget {
  const HomeAnimationPage({super.key});

  @override
  State<HomeAnimationPage> createState() => HomeAnimationPageState();
}

class HomeAnimationPageState extends State<HomeAnimationPage>
    with HomeAnimationLogicPutMixin<HomeAnimationPage> {
  @override
  HomeAnimationLogic initLogic() {
    return HomeAnimationLogic()..state.context = context;
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<HomeAnimationLogic>(
      tag: logicTag,
      assignId: true,
      builder: (_) {
        return const Scaffold(
          body: HomeAnimationListView(),
        );
      },
    );
  }
}
