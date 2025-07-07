/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 21:27:05
 */

import 'package:chat_bottom_container_example/feature/comment/logic/comment_logic.dart';
import 'package:flutter/material.dart';
import 'package:getx_helper/getx_helper.dart';

typedef CommentLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<CommentLogic, W>;

typedef CommentLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<CommentLogic, W>;

enum CommentPanelType {
  none,
  keyboard,
  emoji,
  tool,
}

enum CommentUpdateType {
  titleView,
  descView,
  panelContainer,
}
