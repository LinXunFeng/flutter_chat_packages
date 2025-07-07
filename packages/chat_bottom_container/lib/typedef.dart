/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-07-28 15:07:37
 */

import 'package:flutter/material.dart';

typedef ChatKeyboardChangeKeyboardPanelHeight = double Function(double);

typedef ChatBottomCustomPanelContainer<T> = Widget Function(
  ChatBottomPanelType,
  T? data,
);

enum ChatBottomPanelType {
  none,
  keyboard,
  other,
}

enum ChatBottomHandleFocus {
  none,
  requestFocus,
  unfocus,
}
