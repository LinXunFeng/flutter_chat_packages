/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 14:53:21
 */

import 'package:chat_bottom_container_example/common/route/route.dart';
import 'package:chat_bottom_container_example/feature/chat/page/chat_page.dart';
import 'package:chat_bottom_container_example/feature/comment/page/comment_page.dart';
import 'package:chat_bottom_container_example/feature/home_chat/header/home_chat_header.dart';
import 'package:chat_bottom_container_example/feature/home_chat/logic/home_chat_logic.dart';
import 'package:flutter/material.dart';

extension HomeChatLogicFloatingView on HomeChatLogic {
  void handleFloatingItemClick(HomeChatFloatingItemType type) {
    switch (type) {
      case HomeChatFloatingItemType.pushChatPage:
        NavigationService.push(MyPage.chat);
        break;
      case HomeChatFloatingItemType.showModalBottomSheetChatPage:
        showModalBottomSheet(
          context: NavigationService.context,
          isScrollControlled: true,
          builder: (context) {
            return const FractionallySizedBox(
              heightFactor: 0.8,
              child: ChatPage(),
            );
          },
        );
        break;
      case HomeChatFloatingItemType.showModalBottomSheetCommentPage:
        showModalBottomSheet(
          context: NavigationService.context,
          isScrollControlled: true,
          builder: (context) {
            return const FractionallySizedBox(
              heightFactor: 0.8,
              child: CommentPage(),
            );
          },
        );
        break;
    }
  }
}
