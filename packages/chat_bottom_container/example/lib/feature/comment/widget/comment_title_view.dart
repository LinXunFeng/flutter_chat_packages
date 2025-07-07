/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 22:08:23
 */

import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic.dart';
import 'package:chat_bottom_container_example/feature/comment/state/comment_state.dart';
import 'package:chat_bottom_container_example/feature/comment/widget/comment_text_field_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentTitleView extends StatefulWidget {
  const CommentTitleView({super.key});

  @override
  State<CommentTitleView> createState() => _CommentTitleViewState();
}

class _CommentTitleViewState extends State<CommentTitleView>
    with CommentLogicConsumerMixin<CommentTitleView> {
  CommentState get state => logic.state;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentLogic>(
      tag: logicTag,
      id: CommentUpdateType.titleView,
      builder: (_) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    Widget resultWidget = TextField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      focusNode: state.titleFocusNode,
      readOnly: state.readOnly,
      showCursor: true,
    );
    resultWidget = CommentTextFieldWrapper(
      focusNode: state.titleFocusNode,
      child: resultWidget,
    );
    return resultWidget;
  }
}
