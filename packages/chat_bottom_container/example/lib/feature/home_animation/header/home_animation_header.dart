/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-06-29 16:37:32
 */

import 'package:chat_bottom_container_example/feature/home_animation/logic/home_animation_logic.dart';
import 'package:flutter/material.dart';
import 'package:getx_helper/getx_helper.dart';

typedef HomeAnimationLogicPutMixin<W extends StatefulWidget>
    = GetxLogicPutStateMixin<HomeAnimationLogic, W>;

typedef HomeAnimationLogicConsumerMixin<W extends StatefulWidget>
    = GetxLogicConsumerStateMixin<HomeAnimationLogic, W>;
