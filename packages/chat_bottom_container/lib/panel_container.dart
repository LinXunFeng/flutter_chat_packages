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

  bool isSwitchHeightInKeyboard = false;

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
    final duration = isSwitchHeightInKeyboard
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
        final isSwitchToKeyboardFromPicker =
            ChatBottomPanelType.keyboard == panelType &&
                ChatBottomPanelType.other == lastPanelType;
        double height = 0;

        if (isSwitchToKeyboardFromPicker) {
          height = currentNativeKeyboardHeight == 0
              ? MediaQuery.viewInsetsOf(context).bottom
              : currentNativeKeyboardHeight;
        } else {
          height = MediaQuery.viewInsetsOf(context).bottom;
        }

        if (height < safeAreaBottom) {
          height = safeAreaBottom;
        }

        return SizedBox(width: double.infinity, height: height);
      },
    );
  }

  void onKeyboardHeightChange(double height) {
    if (height == 0) {
      widget.inputFocusNode.unfocus();
      return;
    }
    currentNativeKeyboardHeight = height;
    if (ChatBottomPanelType.keyboard == panelType) {
      isSwitchHeightInKeyboard = true;
    }
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isSwitchHeightInKeyboard = false;
    });
  }

  updatePanelType(
    ChatBottomPanelType type, {
    bool isIgnoreFocusChange = false,
  }) {
    bool needUnFocus;
    switch (type) {
      case ChatBottomPanelType.none:
        needUnFocus = true;
        break;
      case ChatBottomPanelType.keyboard:
        needUnFocus = false;
        widget.inputFocusNode.requestFocus();
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
    if (needUnFocus) {
      widget.inputFocusNode.unfocus();
    } else {
      widget.inputFocusNode.requestFocus();
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
