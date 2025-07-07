/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-05 22:30:20
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:flutter/material.dart';

class ChatAnimationToolPanel extends StatefulWidget {
  final double? height;

  final Color? backgroundColor;

  final bool isPlaceholder;

  const ChatAnimationToolPanel({
    super.key,
    this.height,
    this.backgroundColor,
    this.isPlaceholder = false,
  });

  @override
  State<ChatAnimationToolPanel> createState() => _ChatAnimationToolPanelState();
}

class _ChatAnimationToolPanelState extends State<ChatAnimationToolPanel>
    with ChatAnimationLogicConsumerMixin<ChatAnimationToolPanel> {
  @override
  void initState() {
    super.initState();
    if (widget.isPlaceholder) return;
    debugPrint('initState - tool panel');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: widget.backgroundColor ?? Colors.amber,
      height: widget.height ?? 450,
      child: widget.isPlaceholder ? null : _buildBody(),
    );
  }

  Widget _buildBody() {
    return const Text('Tool Panel');
  }
}
