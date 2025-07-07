/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 21:27:05
 */

import 'package:chat_bottom_container_example/common/route/route.dart';
import 'package:chat_bottom_container_example/feature/comment/header/comment_header.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic.dart';
import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic_panel.dart';
import 'package:chat_bottom_container_example/feature/comment/state/comment_state.dart';
import 'package:chat_bottom_container_example/feature/comment/widget/comment_desc_view.dart';
import 'package:chat_bottom_container_example/feature/comment/widget/comment_panel_bar.dart';
import 'package:chat_bottom_container_example/feature/comment/widget/comment_panel_container.dart';
import 'package:chat_bottom_container_example/feature/comment/widget/comment_title_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage>
    with CommentLogicPutMixin<CommentPage>, RouteAware {
  CommentState get state => logic.state;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MyRoute.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      state.inputFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    state.titleFocusNode.dispose();
    state.descFocusNode.dispose();
    MyRoute.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    logic.hidePanel();
  }

  @override
  CommentLogic initLogic() => CommentLogic();

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<CommentLogic>(
      tag: logicTag,
      assignId: true,
      builder: (_) {
        return _buildContent();
      },
    );
  }

  Widget _buildContent() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Comment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CommentTitleView(),
          _buildSeparator(),
          const Expanded(child: CommentDescView()),
          const CommentPanelBar(),
          const CommentPanelContainer(),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 0.5,
      width: double.infinity,
      color: Colors.grey,
    );
  }
}
