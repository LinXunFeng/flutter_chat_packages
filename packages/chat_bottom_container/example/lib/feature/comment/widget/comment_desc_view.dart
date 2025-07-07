/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 22:08:40
 */

import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic.dart';
import 'package:chat_bottom_container_example/feature/comment/state/comment_state.dart';
import 'package:chat_bottom_container_example/feature/comment/widget/comment_text_field_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentDescView extends StatefulWidget {
  const CommentDescView({super.key});

  @override
  State<CommentDescView> createState() => _CommentDescViewState();
}

class _CommentDescViewState extends State<CommentDescView>
    with CommentLogicConsumerMixin<CommentDescView> {
  CommentState get state => logic.state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentLogic>(
      tag: logicTag,
      id: CommentUpdateType.descView,
      builder: (_) {
        return _buildBody();
      },
    );
  }

  Widget _buildBody() {
    Widget resultWidget = TextField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Description',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      maxLines: 9999,
      focusNode: state.descFocusNode,
      readOnly: state.readOnly,
      showCursor: true,
    );
    resultWidget = CommentTextFieldWrapper(
      focusNode: state.descFocusNode,
      child: resultWidget,
    );
    return resultWidget;
  }
}
