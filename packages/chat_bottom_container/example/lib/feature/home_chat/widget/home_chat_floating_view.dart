/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 16:18:18
 */

import 'package:chat_bottom_container_example/feature/home_chat/header/home_chat_header.dart';
import 'package:chat_bottom_container_example/feature/home_chat/logic/home_chat_logic_floating_view.dart';
import 'package:flutter/material.dart';

class HomeChatFloatingView extends StatefulWidget {
  const HomeChatFloatingView({super.key});

  @override
  State<HomeChatFloatingView> createState() => _HomeChatFloatingViewState();
}

class _HomeChatFloatingViewState extends State<HomeChatFloatingView>
    with HomeChatLogicConsumerMixin<HomeChatFloatingView> {
  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Column(
      children: [
        _buildFloatingBtn(
          type: HomeChatFloatingItemType.pushChatPage,
          icon: Icons.chevron_right_sharp,
        ),
        const SizedBox(height: 10),
        _buildFloatingBtn(
          type: HomeChatFloatingItemType.showModalBottomSheetChatPage,
          icon: Icons.keyboard_arrow_up_sharp,
        ),
        const SizedBox(height: 10),
        _buildFloatingBtn(
          type: HomeChatFloatingItemType.showModalBottomSheetCommentPage,
          icon: Icons.comment,
        ),
      ],
    );
    return resultWidget;
  }

  Widget _buildFloatingBtn({
    required HomeChatFloatingItemType type,
    IconData? icon,
  }) {
    return ElevatedButton(
      onPressed: () {
        logic.handleFloatingItemClick(type);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: Colors.grey[50],
        elevation: 2,
      ),
      child: Icon(icon),
    );
  }
}
