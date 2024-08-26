/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-17 22:25:15
 */

import 'package:chat_bottom_container/constants.dart';
import 'package:chat_bottom_container/listener_manager.dart';
import 'package:chat_bottom_container/typedef.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBottomPanelContainerController<T> {
  _ChatBottomPanelContainerState? _state;

  /// The data used to associate with user-defined panel types.
  T? data;

  /// The current [ChatBottomPanelType].
  ChatBottomPanelType currentPanelType = ChatBottomPanelType.none;

  /// The keyboard height.
  /// This value may be 0 when the keyboard height has never been recorded.
  double get keyboardHeight => _state?.currentNativeKeyboardHeight ?? 0;

  void _attachState(_ChatBottomPanelContainerState state) {
    _state = state;
  }

  void _detachState() {
    _state = null;
  }

  /// Update the panel type.
  ///
  /// [data] is used to associate [ChatBottomPanelType.other] with the data of
  /// the externally defined panel type.
  ///
  /// For other parameters, please go to
  /// [_ChatBottomPanelContainerState.updatePanelType] to view the description.
  void updatePanelType(
    ChatBottomPanelType panelType, {
    T? data,
    ChatBottomHandleFocus forceHandleFocus = ChatBottomHandleFocus.none,
  }) {
    this.data = data;
    _state?.updatePanelType(
      panelType,
      isIgnoreFocusListener: true,
      forceHandleFocus: forceHandleFocus,
    );
  }

  void restoreChatPanel() {
    _state?.updatePanelType(
      _state?.panelType ?? ChatBottomPanelType.none,
      isIgnoreFocusListener: true,
      forceHandleFocus: _state?.handleFocus ?? ChatBottomHandleFocus.none,
    );
  }

  void keepChatPanel() {
    _state?.disableFocusListener();
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

  ChatBottomHandleFocus handleFocus = ChatBottomHandleFocus.none;
  bool isIgnoreFocusListener = false;

  /// Record the height of the keyboard. It will only be updated when the
  /// keyboard pops up and the height of the keyboard itself changes.
  double currentNativeKeyboardHeight = 0;

  /// Determine whether the keyboard height changes due to the keyboard's own
  /// function.
  /// For example, the expansion and closing of the keyboard's own search box.
  bool isKeyboardHeightChangedByItself = false;

  FocusNode get inputFocusNode => widget.inputFocusNode;

  double safeAreaBottom = 0;

  Future<SharedPreferences> get preferences => SharedPreferences.getInstance();

  void setup() async {
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

    final pref = await preferences;
    final keyboardHeight =
        pref.getDouble(ChatBottomContainerPrefKey.keyboardHeight) ?? 0;
    if (keyboardHeight > 0) {
      currentNativeKeyboardHeight = keyboardHeight;
    }
  }

  disableFocusListener() {
    isIgnoreFocusListener = true;
  }

  /// Record the height of the keyboard.
  recordKeyboardHeight(double height) async {
    if (height <= 0) return;
    final pref = await preferences;
    await pref.setDouble(ChatBottomContainerPrefKey.keyboardHeight, height);
  }

  @override
  void initState() {
    super.initState();

    setup();
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
    if (ChatBottomPanelType.other == panelType) return;

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
    // Record the height of the keyboard.
    recordKeyboardHeight(currentNativeKeyboardHeight);
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
  ///
  /// [forceHandleFocus] is used to force focus handling. When you want the
  /// input box to have focus and not pop up the system keyboard, you need to
  /// set it to [ChatBottomHandleFocus.requestFocus]. In addition, you also need
  /// to set the [TextField.readOnly] to true.
  updatePanelType(
    ChatBottomPanelType type, {
    bool isIgnoreFocusListener = false,
    ChatBottomHandleFocus forceHandleFocus = ChatBottomHandleFocus.none,
  }) {
    handleFocus = ChatBottomHandleFocus.none;
    switch (type) {
      case ChatBottomPanelType.none:
        // The soft keyboard may hide, but the input box still has focus.
        break;
      case ChatBottomPanelType.keyboard:
        handleFocus = ChatBottomHandleFocus.requestFocus;
        break;
      case ChatBottomPanelType.other:
        handleFocus = ChatBottomHandleFocus.unfocus;
        break;
    }
    // Determine whether it need to force the focus to be handled.
    switch (forceHandleFocus) {
      case ChatBottomHandleFocus.none:
        break;
      case ChatBottomHandleFocus.requestFocus:
        handleFocus = ChatBottomHandleFocus.requestFocus;
        break;
      case ChatBottomHandleFocus.unfocus:
        handleFocus = ChatBottomHandleFocus.unfocus;
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
    switch (handleFocus) {
      case ChatBottomHandleFocus.unfocus:
        widget.inputFocusNode.unfocus();
        break;
      case ChatBottomHandleFocus.requestFocus:
        widget.inputFocusNode.requestFocus();
        break;
      case ChatBottomHandleFocus.none:
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
