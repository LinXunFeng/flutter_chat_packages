/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 18:54:53
 */

import 'package:chat_bottom_container_example/feature/chat/header/chat_header.dart';
import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic_panel_container.dart';
import 'package:flutter/material.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({super.key});

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView>
    with ChatLogicConsumerMixin<ChatListView> {
  @override
  Widget build(BuildContext context) {
    Widget resultWidget = ListView.builder(
      padding: EdgeInsets.zero,
      reverse: true,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item $index'),
        );
      },
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
