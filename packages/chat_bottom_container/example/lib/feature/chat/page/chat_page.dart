/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 21:00:10
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/common/route/route.dart';
import 'package:chat_bottom_container_example/feature/chat/header/chat_header.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic_panel_container.dart';
import 'package:chat_bottom_container_example/feature/chat/state/chat_state.dart';
import 'package:chat_bottom_container_example/feature/chat/widget/chat_panel_bar.dart';
import 'package:chat_bottom_container_example/feature/chat/widget/chat_list_view.dart';
import 'package:chat_bottom_container_example/feature/chat/widget/chat_panel_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  final double? safeAreaBottom;

  final bool showAppBar;

  final ChatKeyboardChangeKeyboardPanelHeight? changeKeyboardPanelHeight;

  final Function(ChatBottomPanelContainerController)? onControllerCreated;

  const ChatPage({
    super.key,
    this.safeAreaBottom,
    this.showAppBar = true,
    this.changeKeyboardPanelHeight,
    this.onControllerCreated,
  });

  @override
  State<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage>
    with ChatLogicPutMixin<ChatPage>, RouteAware {
  ChatState get state => logic.state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyRoute.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    state.inputFocusNode.dispose();
    MyRoute.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    logic.hidePanel();
  }

  @override
  ChatLogic initLogic() {
    return ChatLogic()..state.pageState = this;
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<ChatLogic>(
      tag: logicTag,
      assignId: true,
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _buildAppBar(),
          body: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: ChatListView()),
              ChatPanelBar(),
              ChatPanelContainer(),
            ],
          ),
        );
      },
    );
  }

  AppBar? _buildAppBar() {
    return widget.showAppBar
        ? AppBar(
            title: const Text('Chat Page'),
          )
        : null;
  }
}
