/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:29:25
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:flutter/material.dart';

class ChatAnimationEmojiPanel extends StatefulWidget {
  final double? height;

  final Color? backgroundColor;

  final bool isPlaceholder;

  const ChatAnimationEmojiPanel({
    super.key,
    this.height,
    this.backgroundColor,
    this.isPlaceholder = false,
  });

  @override
  State<ChatAnimationEmojiPanel> createState() =>
      _ChatAnimationEmojiPanelState();
}

class _ChatAnimationEmojiPanelState extends State<ChatAnimationEmojiPanel>
    with ChatAnimationLogicConsumerMixin<ChatAnimationEmojiPanel> {
  @override
  @override
  void initState() {
    super.initState();
    if (widget.isPlaceholder) return;
    debugPrint('initState - emoji panel');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: widget.backgroundColor ?? Colors.blue,
      height: widget.height ?? 350,
      child: widget.isPlaceholder ? null : _buildBody(),
    );
  }

  Widget _buildBody() {
    return const Text('Emoji Panel');
  }
}
