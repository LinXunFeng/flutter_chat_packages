/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 21:27:05
 */

import 'package:chat_bottom_container/panel_container.dart';
import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:flutter/material.dart';

class CommentState {
  final FocusNode titleFocusNode = FocusNode();

  final FocusNode descFocusNode = FocusNode();

  late FocusNode inputFocusNode = titleFocusNode;

  final controller = ChatBottomPanelContainerController<CommentPanelType>();

  CommentPanelType currentPanelType = CommentPanelType.none;

  bool readOnly = false;
}
