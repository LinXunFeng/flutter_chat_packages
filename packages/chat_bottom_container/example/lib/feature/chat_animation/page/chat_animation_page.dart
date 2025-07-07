/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:03:14
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/state/chat_animation_state.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/chat_animation_list_view.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/chat_animation_panel_bar.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/widget/panel_container/chat_animation_panel_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatAnimationPage extends StatefulWidget {
  const ChatAnimationPage({super.key});

  @override
  State<ChatAnimationPage> createState() => ChatAnimationPageState();
}

class ChatAnimationPageState extends State<ChatAnimationPage>
    with ChatAnimationLogicPutMixin<ChatAnimationPage>, RouteAware {
  ChatAnimationState get state => logic.state;

  @override
  ChatAnimationLogic initLogic() => ChatAnimationLogic();

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<ChatAnimationLogic>(
      tag: logicTag,
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(),
          body: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: ChatAnimationListView()),
              ChatAnimationPanelBar(),
              ChatAnimationPanelContainer(),
            ],
          ),
        );
      },
    );
  }

  AppBar? _buildAppBar() {
    String name = state.animationType.name;
    return AppBar(
      title: Text('Chat - ${name[0].toUpperCase() + name.substring(1)}'),
    );
  }
}
