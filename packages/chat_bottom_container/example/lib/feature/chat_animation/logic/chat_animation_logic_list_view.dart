/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-07-06 15:02:42
 */

import 'package:chat_bottom_container_example/feature/chat_animation/header/chat_animation_header.dart';
import 'package:chat_bottom_container_example/feature/chat_animation/logic/chat_animation_logic.dart';
import 'package:flutter/material.dart';

extension ChatAnimationLogicListView on ChatAnimationLogic {
  bool listViewReverse() {
    switch (state.animationType) {
      case ChatAnimationType.animatedSwitcherPlus:
      case ChatAnimationType.animatedSwitcherTransitions:
      case ChatAnimationType.transitionedIndexedStack:
        return false;
      default:
        return true;
    }
  }

  int? listViewItemCount() {
    switch (state.animationType) {
      case ChatAnimationType.animatedSwitcherPlus:
        return state.switcherPlusTypes.length;
      case ChatAnimationType.animatedSwitcherTransitions:
        return state.switcherTransitionTypes.length;
      case ChatAnimationType.transitionedIndexedStack:
        return state.indexedStackTransitionTypes.length;
      default:
        return null;
    }
  }

  Widget listViewItemBuilder(int index) {
    String title;
    Widget? trailing;
    switch (state.animationType) {
      case ChatAnimationType.animatedSwitcherPlus:
        final type = state.switcherPlusTypes[index];
        title = type.name;
        trailing = const Icon(Icons.ads_click);
        break;
      case ChatAnimationType.animatedSwitcherTransitions:
        final type = state.switcherTransitionTypes[index];
        title = type.name;
        trailing = const Icon(Icons.workspaces_filled);
      case ChatAnimationType.transitionedIndexedStack:
        final type = state.indexedStackTransitionTypes[index];
        title = type.name;
        trailing = const Icon(Icons.api_outlined);
      default:
        title = 'Item $index';
        break;
    }

    return ListTile(
      title: Text(title),
      trailing: trailing,
      onTap: () {
        handleListViewItemTap(index);
      },
    );
  }

  void handleListViewItemTap(int index) {
    String typeName = '';
    switch (state.animationType) {
      case ChatAnimationType.animatedSwitcherPlus:
        final type = state.switcherPlusTypes[index];
        if (type == state.currentSwitcherPlusType) return;
        state.currentSwitcherPlusType = type;
        typeName = type.name;
        break;
      case ChatAnimationType.animatedSwitcherTransitions:
        final type = state.switcherTransitionTypes[index];
        if (type == state.currentSwitcherTransitionType) return;
        state.currentSwitcherTransitionType = type;
        typeName = type.name;
        break;
      case ChatAnimationType.transitionedIndexedStack:
        final type = state.indexedStackTransitionTypes[index];
        if (type == state.currentIndexedStackTransitionType) return;
        state.currentIndexedStackTransitionType = type;
        typeName = type.name;
        break;
      default:
        break;
    }
    if (typeName.isNotEmpty) {
      update([
        ChatAnimationUpdateType.customPanelContainer,
      ]);
      showSnackBar(message: 'Use $typeName animation');
    }
  }
}
