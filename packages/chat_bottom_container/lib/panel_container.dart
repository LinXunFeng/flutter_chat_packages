/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-17 22:25:15
 */

import 'package:chat_bottom_container/listener_manager.dart';
import 'package:flutter/material.dart';

typedef ChatKeyboardChangeKeyboardPanelHeight = double Function(double);

enum ChatBottomPanelType {
  none,
  keyboard,
  other,
}

class ChatBottomPanelContainerController<T> {
  _ChatBottomPanelContainerState? _state;

  /// The data used to associate with user-defined panel types.
  T? data;

  /// The current [ChatBottomPanelType].
  ChatBottomPanelType currentPanelType = ChatBottomPanelType.none;

  void _attachState(_ChatBottomPanelContainerState state) {
    _state = state;
  }

  void _detachState() {
    _state = null;
  }

  /// Update the panel type.
  void updatePanelType(
    ChatBottomPanelType panelType, {
    T? data,
    bool handleFocus = false,
  }) {
    this.data = data;
    _state?.updatePanelType(
      panelType,
      isIgnoreFocusListener: true,
      handleFocus: handleFocus,
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
    this.safeAreaBottom,
    this.changeKeyboardPanelHeight,
  });

  /// The controller of [ChatBottomPanelContainer].
  final ChatBottomPanelContainerController<T> controller;

  /// The focus node of the input box.
  final FocusNode inputFocusNode;

  /// The widget of the other panel.
  final Widget Function(T? data) otherPanelWidget;

  /// The callback when the panel type changes.
  final void Function(ChatBottomPanelType, T? data)? onPanelTypeChange;

  /// The background color of the panel container.
  final Color panelBgColor;

  /// The bottom height of the safe area.
  /// If it is null, the widget will automatically calculate the bottom height
  /// of the safe area.
  final double? safeAreaBottom;

  /// The callback to change the height of the keyboard panel.
  final ChatKeyboardChangeKeyboardPanelHeight? changeKeyboardPanelHeight;

  @override
  State<ChatBottomPanelContainer> createState() =>
      _ChatBottomPanelContainerState<T>();
}

class _ChatBottomPanelContainerState<T>
    extends State<ChatBottomPanelContainer<T>> {
  String chatKeyboardManagerId = '';

  ChatBottomPanelType lastPanelType = ChatBottomPanelType.none;
  ChatBottomPanelType panelType = ChatBottomPanelType.none;

  bool isIgnoreFocusListener = false;

  double currentNativeKeyboardHeight = 0;

  bool isKeyboardHeightChangedByItself = false;

  FocusNode get inputFocusNode => widget.inputFocusNode;

  double safeAreaBottom = 0;

  @override
  void initState() {
    super.initState();
    safeAreaBottom = widget.safeAreaBottom ?? 0;
    widget.controller._attachState(this);
    chatKeyboardManagerId = ChatBottomContainerListenerManager().register(
      onKeyboardHeightChange,
    );

    inputFocusNode.addListener(() {
      if (isIgnoreFocusListener) return;
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Get the accurate bottom height of safe area.
        if (widget.safeAreaBottom == null)
          Positioned(
            left: 0,
            bottom: 0,
            child: ChatKeyboardSafeAreaDataView(
              safeAreaBottom: (value) async {
                safeAreaBottom = value;
                await WidgetsBinding.instance.endOfFrame;
                setState(() {});
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

  /// Fetch the panel widget according to [panelType].
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

        // The height of the keyboard container can be adjusted by developer.
        height = widget.changeKeyboardPanelHeight?.call(height) ?? height;

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

  /// Update the panel type.
  ///
  /// [isIgnoreFocusListener] is used to ignore the focus change event listener.
  /// [handleFocus] is used to determine whether to handle the focus of the
  /// input box in this method.
  updatePanelType(
    ChatBottomPanelType type, {
    bool isIgnoreFocusListener = false,
    bool handleFocus = false,
  }) {
    bool? needUnFocus;
    switch (type) {
      case ChatBottomPanelType.none:
        // The soft keyboard may hide, but the input box still has focus.
        break;
      case ChatBottomPanelType.keyboard:
        needUnFocus = handleFocus ? false : null;
        break;
      case ChatBottomPanelType.other:
        needUnFocus = handleFocus ? true : null;
        break;
    }
    lastPanelType = panelType;
    panelType = type;
    widget.controller.currentPanelType = panelType;
    widget.onPanelTypeChange?.call(
      panelType,
      widget.controller.data,
    );
    this.isIgnoreFocusListener = isIgnoreFocusListener;
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
      this.isIgnoreFocusListener = false;
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

    // On some Android devices, when the keyboard is displayed and push the
    // next page, the viewPadding.bottom changes twice, the first time is 0,
    // the second time is non-0 and the second time it is the correct value.
    if (haveSetup && safeAreaBottom != 0) return;
    haveSetup = true;
    double bottom = MediaQuery.viewPaddingOf(context).bottom;
    safeAreaBottom = bottom;
    widget.safeAreaBottom?.call(safeAreaBottom);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
