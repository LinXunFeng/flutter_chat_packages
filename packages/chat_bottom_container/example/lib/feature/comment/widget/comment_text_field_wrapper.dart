/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 22:06:23
 */

import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic_input_view.dart';
import 'package:chat_bottom_container_example/feature/comment/state/comment_state.dart';
import 'package:flutter/material.dart';

class CommentTextFieldWrapper extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;

  const CommentTextFieldWrapper({
    super.key,
    required this.child,
    required this.focusNode,
  });

  @override
  State<CommentTextFieldWrapper> createState() =>
      _CommentTextFieldWrapperState();
}

class _CommentTextFieldWrapperState extends State<CommentTextFieldWrapper>
    with CommentLogicConsumerMixin<CommentTextFieldWrapper> {
  CommentState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    Widget resultWidget = Listener(
      onPointerUp: (event) {
        logic.handleInputViewOnPointerUp();
      },
      onPointerDown: (event) {
        logic.handleInputViewOnPointerDown(widget.focusNode);
      },
      child: widget.child,
    );
    resultWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: resultWidget,
    );
    return resultWidget;
  }
}
