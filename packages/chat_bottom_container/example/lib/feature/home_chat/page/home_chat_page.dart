/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 14:53:21
 */

import 'package:chat_bottom_container_example/feature/chat/page/chat_page.dart';
import 'package:chat_bottom_container_example/feature/home/logic/home_logic.dart';
import 'package:chat_bottom_container_example/feature/home_chat/header/home_chat_header.dart';
import 'package:chat_bottom_container_example/feature/home_chat/logic/home_chat_logic.dart';
import 'package:chat_bottom_container_example/feature/home_chat/state/home_chat_state.dart';
import 'package:chat_bottom_container_example/feature/home_chat/widget/home_chat_floating_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_helper/getx_helper.dart';

class HomeChatPage extends StatefulWidget {
  const HomeChatPage({super.key});

  @override
  State<HomeChatPage> createState() => HomeChatPageState();
}

class HomeChatPageState extends State<HomeChatPage>
    with HomeChatLogicPutMixin<HomeChatPage> {
  HomeChatState get state => logic.state;

  @override
  HomeChatLogic initLogic() {
    return HomeChatLogic()
      ..state.context = context
      ..state.homeLogic = context.getxLogic<HomeLogic>();
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<HomeChatLogic>(
      tag: logicTag,
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        _buildChatView(),
        const Positioned(
          top: 150,
          right: 10,
          child: HomeChatFloatingView(),
        ),
      ],
    );
  }

  Widget _buildChatView() {
    return ChatPage(
      safeAreaBottom: 0,
      changeKeyboardPanelHeight: (keyboardHeight) {
        // Here we need to subtract the height of BottomNavigationBar.
        final renderObj = state
            .homeLogic.state.bottomNavigationBarKey.currentContext
            ?.findRenderObject();
        if (renderObj is! RenderBox) return keyboardHeight;
        return keyboardHeight - renderObj.size.height;
      },
      onControllerCreated: (controller) {
        state.controller = controller;
      },
    );
  }
}
