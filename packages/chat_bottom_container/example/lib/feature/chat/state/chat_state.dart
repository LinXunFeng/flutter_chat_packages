/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 21:00:10
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/feature/chat/header/chat_header.dart';
import 'package:chat_bottom_container_example/feature/chat/page/chat_page.dart';
import 'package:flutter/material.dart';

class ChatState {
  late ChatPageState pageState;

  ChatPage get pageWidget => pageState.widget;

  final FocusNode inputFocusNode = FocusNode();

  final controller = ChatBottomPanelContainerController<ChatPanelType>();

  ChatPanelType currentPanelType = ChatPanelType.none;

  bool readOnly = false;
}
