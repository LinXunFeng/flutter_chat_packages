/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2025-03-10 23:02:20
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/main.dart';
import 'package:flutter/material.dart';

enum PanelType {
  none,
  keyboard,
  emoji,
  tool,
}

class CommentPage extends StatefulWidget {
  const CommentPage({
    super.key,
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> with RouteAware {
  Color panelBgColor = const Color(0xFFF5F5F5);

  FocusNode inputFocusNode = FocusNode();

  final FocusNode titleFocusNode = FocusNode();

  final FocusNode descFocusNode = FocusNode();

  final controller = ChatBottomPanelContainerController<PanelType>();

  PanelType currentPanelType = PanelType.none;

  bool readOnly = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.routeObserver.subscribe(this, ModalRoute.of(context)!);

    inputFocusNode = titleFocusNode;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      inputFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    inputFocusNode.dispose();
    App.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    hidePanel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Comment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTitleView(),
          _buildSeparator(),
          Expanded(child: _buildDescView()),
          _buildPanelView(),
          _buildPanelContainer(),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 0.5,
      width: double.infinity,
      color: Colors.grey,
    );
  }

  Widget _buildPanelContainer() {
    return ChatBottomPanelContainer<PanelType>(
      controller: controller,
      inputFocusNode: inputFocusNode,
      otherPanelWidget: (type) {
        if (type == null) return const SizedBox.shrink();
        switch (type) {
          case PanelType.emoji:
            return _buildEmojiPickerPanel();
          case PanelType.tool:
            return _buildToolPanel();
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: (panelType, data) {
        debugPrint('panelType: $panelType');
        switch (panelType) {
          case ChatBottomPanelType.none:
            currentPanelType = PanelType.none;
            break;
          case ChatBottomPanelType.keyboard:
            currentPanelType = PanelType.keyboard;
            break;
          case ChatBottomPanelType.other:
            if (data == null) return;
            switch (data) {
              case PanelType.emoji:
                currentPanelType = PanelType.emoji;
                break;
              case PanelType.tool:
                currentPanelType = PanelType.tool;
                break;
              default:
                currentPanelType = PanelType.none;
                break;
            }
            break;
        }
      },
      panelBgColor: panelBgColor,
    );
  }

  Widget _buildToolPanel() {
    return Container(
      height: 450,
      color: Colors.red[50],
      child: const Center(
        child: Text('Tool Panel'),
      ),
    );
  }

  Widget _buildEmojiPickerPanel() {
    // If the keyboard height has been recorded, priority is given to setting
    // the height to the keyboard height.
    double height = 300;
    final keyboardHeight = controller.keyboardHeight;
    if (keyboardHeight != 0) {
      height = keyboardHeight;
    }

    return Container(
      padding: EdgeInsets.zero,
      height: height,
      color: Colors.blue[50],
      child: const Center(
        child: Text('Emoji Panel'),
      ),
    );
  }

  Widget _buildTitleView() {
    Widget resultWidget = TextField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Title',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      focusNode: titleFocusNode,
      readOnly: readOnly,
      showCursor: true,
    );
    resultWidget = _textFieldWrapper(
      resultWidget,
      focusNode: titleFocusNode,
    );
    return resultWidget;
  }

  Widget _buildDescView() {
    Widget resultWidget = TextField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Description',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      maxLines: 9999,
      focusNode: descFocusNode,
      readOnly: readOnly,
      showCursor: true,
    );
    resultWidget = _textFieldWrapper(
      resultWidget,
      focusNode: descFocusNode,
    );
    return resultWidget;
  }

  Widget _textFieldWrapper(
    Widget child, {
    required FocusNode focusNode,
  }) {
    Widget resultWidget = Listener(
      onPointerUp: (event) {
        // Currently it may be emojiPanel.
        if (readOnly) {
          updatePanelType(PanelType.keyboard);
        }
      },
      onPointerDown: (event) {
        if (inputFocusNode == focusNode) return;
        inputFocusNode = focusNode;
        setState(() {});
      },
      child: child,
    );
    resultWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: resultWidget,
    );
    return resultWidget;
  }

  Widget _buildPanelView() {
    Widget resultWidget = Row(
      children: [
        const FlutterLogo(size: 30),
        const Spacer(),
        _buildEmojiBtn(),
        _buildToolBtn(),
      ],
    );
    resultWidget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      color: Colors.white,
      child: resultWidget,
    );
    return resultWidget;
  }

  Widget _buildToolBtn() {
    return GestureDetector(
      child: const Icon(Icons.add, size: 30),
      onTap: () {
        updatePanelType(
          PanelType.tool == currentPanelType
              ? PanelType.keyboard
              : PanelType.tool,
        );
      },
    );
  }

  Widget _buildEmojiBtn() {
    return GestureDetector(
      child: const Icon(Icons.emoji_emotions_outlined, size: 30),
      onTap: () {
        updatePanelType(
          PanelType.emoji == currentPanelType
              ? PanelType.keyboard
              : PanelType.emoji,
        );
      },
    );
  }

  updatePanelType(PanelType type) async {
    final isSwitchToKeyboard = PanelType.keyboard == type;
    final isSwitchToEmojiPanel = PanelType.emoji == type;
    bool isUpdated = false;
    switch (type) {
      case PanelType.keyboard:
        updateInputView(isReadOnly: false);
        break;
      case PanelType.emoji:
        isUpdated = updateInputView(isReadOnly: true);
        break;
      default:
        break;
    }

    updatePanelTypeFunc() {
      controller.updatePanelType(
        isSwitchToKeyboard
            ? ChatBottomPanelType.keyboard
            : ChatBottomPanelType.other,
        data: type,
        forceHandleFocus: isSwitchToEmojiPanel
            ? ChatBottomHandleFocus.requestFocus
            : ChatBottomHandleFocus.none,
      );
    }

    if (isUpdated) {
      // Waiting for the input view to update.
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        updatePanelTypeFunc();
      });
    } else {
      updatePanelTypeFunc();
    }
  }

  hidePanel() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
    }
    updateInputView(isReadOnly: false);
    if (ChatBottomPanelType.none == controller.currentPanelType) return;
    controller.updatePanelType(ChatBottomPanelType.none);
  }

  bool updateInputView({
    required bool isReadOnly,
  }) {
    if (readOnly != isReadOnly) {
      readOnly = isReadOnly;
      // You can just refresh the input view.
      setState(() {});
      return true;
    }
    return false;
  }
}
