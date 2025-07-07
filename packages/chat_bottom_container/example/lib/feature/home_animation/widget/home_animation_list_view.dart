/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 16:47:14
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/home_animation/header/home_animation_header.dart';
import 'package:chat_bottom_container_example/feature/home_animation/logic/home_animation_logic_list_view.dart';
import 'package:chat_bottom_container_example/feature/home_animation/state/home_animation_state.dart';
import 'package:flutter/material.dart';

class HomeAnimationListView extends StatefulWidget {
  const HomeAnimationListView({super.key});

  @override
  State<HomeAnimationListView> createState() => _HomeAnimationListViewState();
}

class _HomeAnimationListViewState extends State<HomeAnimationListView>
    with HomeAnimationLogicConsumerMixin<HomeAnimationListView> {
  HomeAnimationState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: state.animationTypes.map((type) {
        return _buildItem(type: type);
      }).toList(),
    );
  }

  Widget _buildItem({
    required ChatAnimationType type,
  }) {
    String name = type.name;
    return ListTile(
      title: Text(name[0].toUpperCase() + name.substring(1)),
      onTap: () {
        logic.handleListItemTap(type);
      },
    );
  }
}
