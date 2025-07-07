/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:11:55
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_list_view.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic_panel_container.dart';
import 'package:flutter/material.dart';

class ChatAnimationListView extends StatefulWidget {
  const ChatAnimationListView({super.key});

  @override
  State<ChatAnimationListView> createState() => _ChatAnimationListViewState();
}

class _ChatAnimationListViewState extends State<ChatAnimationListView>
    with ChatAnimationLogicConsumerMixin<ChatAnimationListView> {
  @override
  Widget build(BuildContext context) {
    Widget resultWidget = ListView.builder(
      padding: EdgeInsets.zero,
      reverse: logic.listViewReverse(),
      itemBuilder: (context, index) {
        return logic.listViewItemBuilder(index);
      },
      itemCount: logic.listViewItemCount(),
    );
    resultWidget = Listener(
      child: resultWidget,
      onPointerDown: (event) {
        // Hide panel when touch ListView.
        logic.hidePanel();
      },
    );
    return resultWidget;
  }
}
