/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-17 22:25:15
 */

import 'package:chat_bottom_container/listener_manager.dart';
import 'package:flutter/material.dart';

enum ChatBottomPanelType {
  none,
  keyboard,
  other,
}

class ChatBottomPanelContainerController<T> {
  _ChatBottomPanelContainerState? _state;

  T? data;

  ChatBottomPanelType currentPanelType = ChatBottomPanelType.none;

  void _attachState(_ChatBottomPanelContainerState state) {
    _state = state;
  }

  void _detachState() {
    _state = null;
  }

  void updatePanelType(
    ChatBottomPanelType panelType, {
    T? data,
  }) {
    this.data = data;
    _state?.updatePanelType(
      panelType,
      isIgnoreFocusChange: true,
    );
  }
}

class ChatBottomPanelContainer<T> extends StatefulWidget {
  const ChatBottomPanelContainer({
    super.key,
    required this.controller,
    required this.inputFocusNode,
    required this.otherPanelWidget,
    this.onPanelTypeChange,
    this.panelBgColor = Colors.white,
  });

  final ChatBottomPanelContainerController<T> controller;

  final FocusNode inputFocusNode;

  final Widget Function(T? data) otherPanelWidget;

  final void Function(ChatBottomPanelType, T? data)? onPanelTypeChange;

  final Color panelBgColor;

  @override
  State<ChatBottomPanelContainer> createState() =>
      _ChatBottomPanelContainerState<T>();
}

class _ChatBottomPanelContainerState<T>
    extends State<ChatBottomPanelContainer<T>> with WidgetsBindingObserver {
  String chatKeyboardManagerId = '';

  ChatBottomPanelType lastPanelType = ChatBottomPanelType.none;
  ChatBottomPanelType panelType = ChatBottomPanelType.none;

  bool isIgnoreFocusChange = false;

  double currentNativeKeyboardHeight = 0;

  bool isKeyboardHeightChangedByItself = false;

  FocusNode get inputFocusNode => widget.inputFocusNode;

  double safeAreaBottom = 0;

  @override
  void initState() {
    super.initState();
    widget.controller._attachState(this);
    chatKeyboardManagerId = ChatBottomContainerListenerManager().register(
      onKeyboardHeightChange,
    );

    inputFocusNode.addListener(() {
      if (isIgnoreFocusChange) return;
      if (inputFocusNode.hasFocus) {
        updatePanelType(ChatBottomPanelType.keyboard);
      } else {
        updatePanelType(ChatBottomPanelType.none);
      }
    });
  }

  @override
  void dispose() {
    widget.controller._detachState();
    ChatBottomContainerListenerManager().unregister(chatKeyboardManagerId);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        widget.inputFocusNode.unfocus();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Get the accurate bottom height of safe area.
        Positioned(
          left: 0,
          bottom: 0,
          child: ChatKeyboardSafeAreaDataView(
            safeAreaBottom: (value) {
              safeAreaBottom = value;
            },
          ),
        ),
        _buildPanelContainer(),
      ],
    );
  }

  Widget _buildPanelContainer() {
    // When the keyboard height changes due to the keyboard's internal
    // functions, the animation duration should be shorter.
    final duration = isKeyboardHeightChangedByItself
        ? const Duration(milliseconds: 50)
        : const Duration(milliseconds: 200);
    const curve = Curves.linear;
    Widget resultWidget = AnimatedSize(
      alignment: Alignment.topCenter,
      duration: duration,
      curve: curve,
      child: fetchPanel(),
    );
    return Container(
      color: widget.panelBgColor,
      child: resultWidget,
    );
  }

  Widget fetchPanel() {
    Widget resultWidget;
    switch (panelType) {
      case ChatBottomPanelType.other:
        resultWidget = _buildOtherPanel();
      case ChatBottomPanelType.keyboard:
        resultWidget = _buildKeyboardPlaceholderPanel();
      case ChatBottomPanelType.none:
        resultWidget = _buildSafeArea();
    }
    return resultWidget;
  }

  Widget _buildSafeArea() {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          height: safeAreaBottom,
        );
      },
    );
  }

  Widget _buildOtherPanel() {
    return widget.otherPanelWidget.call(widget.controller.data);
  }

  Widget _buildKeyboardPlaceholderPanel() {
    return Builder(
      builder: (context) {
        final isSwitchToKeyboardFromOtherPanelType =
            ChatBottomPanelType.keyboard == panelType &&
                ChatBottomPanelType.other == lastPanelType;
        double height = 0;

        if (isSwitchToKeyboardFromOtherPanelType) {
          // When switching to the keyboard from other panel. The height of
          // keyboard container should be fixed in order to achieve a smooth
          // switching effect. 
          height = currentNativeKeyboardHeight == 0
              ? MediaQuery.viewInsetsOf(context).bottom
              : currentNativeKeyboardHeight;
        } else {
          // Follow the keyboard pop up from the bottom.
          height = MediaQuery.viewInsetsOf(context).bottom;
        }

        // To prevent jitter.
        if (height < safeAreaBottom) {
          height = safeAreaBottom;
        }

        return SizedBox(width: double.infinity, height: height);
      },
    );
  }

  void onKeyboardHeightChange(double height) {
    // Ignore it if the height change is not caused by the chat input box.
    // e.g. the form input boxes on the page.
    if (!widget.inputFocusNode.hasFocus) return;

    if (height == 0) {
      // Android
      // When you press the back key on Android 10 and below, the input box will
      // not lose focus, but the keyboard will hide.
      //
      // iOS
      // When an external keyboard is connected, the soft keyboard hide, but
      // the input box remains in focus.
      if (ChatBottomPanelType.keyboard == panelType) {
        updatePanelType(ChatBottomPanelType.none);
      }
      return;
    }

    // The soft keyboard pops up.
    currentNativeKeyboardHeight = height;
    switch (panelType) {
      case ChatBottomPanelType.none:
        // Switch to the keyboard panel.
        updatePanelType(ChatBottomPanelType.keyboard);
        break;
      case ChatBottomPanelType.keyboard:
        isKeyboardHeightChangedByItself = true;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          isKeyboardHeightChangedByItself = false;
        });
        setState(() {});
        break;
      case ChatBottomPanelType.other:
        // Unexpected situation, ignore.
        break;
    }
  }

  updatePanelType(
    ChatBottomPanelType type, {
    bool isIgnoreFocusChange = false,
  }) {
    bool? needUnFocus;
    switch (type) {
      case ChatBottomPanelType.none:
        // The soft keyboard may hide, but the input box still has focus.
        break;
      case ChatBottomPanelType.keyboard:
        needUnFocus = false;
        break;
      case ChatBottomPanelType.other:
        needUnFocus = true;
        break;
    }
    lastPanelType = panelType;
    panelType = type;
    widget.controller.currentPanelType = panelType;
    widget.onPanelTypeChange?.call(
      panelType,
      widget.controller.data,
    );
    this.isIgnoreFocusChange = isIgnoreFocusChange;
    setState(() {});
    switch (needUnFocus) {
      case true:
        widget.inputFocusNode.unfocus();
        break;
      case false:
        widget.inputFocusNode.requestFocus();
        break;
      case null:
        break;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      this.isIgnoreFocusChange = false;
    });
  }
}

class ChatKeyboardSafeAreaDataView extends StatefulWidget {
  final Function(double)? safeAreaBottom;

  const ChatKeyboardSafeAreaDataView({
    super.key,
    this.safeAreaBottom,
  });

  @override
  State<ChatKeyboardSafeAreaDataView> createState() =>
      _ChatKeyboardSafeAreaDataViewState();
}

class _ChatKeyboardSafeAreaDataViewState
    extends State<ChatKeyboardSafeAreaDataView> {
  double safeAreaBottom = 0;

  bool haveSetup = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (haveSetup) return;
    haveSetup = true;
    double bottom = MediaQuery.viewPaddingOf(context).bottom;
    if (bottom == 0) {
      bottom = MediaQuery.viewInsetsOf(context).bottom;
    }
    safeAreaBottom = bottom;
    widget.safeAreaBottom?.call(safeAreaBottom);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
