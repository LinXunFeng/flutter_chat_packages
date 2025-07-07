/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-28 20:25:44
 */

import 'package:flutter/material.dart';
import 'package:getx_helper/getx_helper.dart';
import 'package:chat_bottom_container_example/feature/home/logic/home_logic.dart';

typedef HomeLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<HomeLogic, W>;

typedef HomeLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<HomeLogic, W>;

enum HomeUpdateType {
  bottomNavBar,
}
