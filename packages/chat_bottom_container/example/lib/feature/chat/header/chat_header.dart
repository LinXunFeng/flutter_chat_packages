/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 21:00:10
 */

import 'package:chat_bottom_container_example/feature/chat/logic/chat_logic.dart';
import 'package:flutter/material.dart';
import 'package:getx_helper/getx_helper.dart';

typedef ChatLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<ChatLogic, W>;

typedef ChatLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<ChatLogic, W>;

enum ChatPanelType {
  none,
  keyboard,
  emoji,
  tool,
}

enum ChatUpdateType {
  inputView,
}
