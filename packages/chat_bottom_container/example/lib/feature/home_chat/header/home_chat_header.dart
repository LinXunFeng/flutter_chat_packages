/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 14:53:21
 */

import 'package:chat_bottom_container_example/feature/home_chat/logic/home_chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:getx_helper/getx_helper.dart';

typedef HomeChatLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<HomeChatLogic, W>;

typedef HomeChatLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<HomeChatLogic, W>;

enum HomeChatFloatingItemType {
  pushChatPage,
  showModalBottomSheetChatPage,
  showModalBottomSheetCommentPage,
}
