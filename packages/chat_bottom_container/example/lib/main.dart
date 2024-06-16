import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

enum PanelType {
  none,
  keyboard,
  emoji,
  tool,
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color panelBgColor = const Color(0xFFF5F5F5);

  final FocusNode inputFocusNode = FocusNode();

  ChatBottomPanelContainerController<PanelType> controller =
      ChatBottomPanelContainerController<PanelType>();

  PanelType currentPanelType = PanelType.none;

  @override
  void dispose() {
    inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
          _buildInputView(),
          _buildPanelContainer(),
        ],
      ),
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
      height: 550,
      color: Colors.red[50],
      child: const Center(
        child: Text('Tool Panel'),
      ),
    );
  }

  Widget _buildEmojiPickerPanel() {
    return Container(
      padding: EdgeInsets.zero,
      height: 300,
      color: Colors.blue[50],
      child: const Center(
        child: Text('Emoji Panel'),
      ),
    );
  }

  Widget _buildInputView() {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              focusNode: inputFocusNode,
            ),
          ),
          GestureDetector(
            child: const Icon(Icons.emoji_emotions_outlined, size: 30),
            onTap: () {
              updatePanelType(PanelType.emoji);
            },
          ),
          GestureDetector(
            child: const Icon(Icons.add, size: 30),
            onTap: () {
              updatePanelType(PanelType.tool);
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  updatePanelType(PanelType type) {
    controller.updatePanelType(
      type == currentPanelType
          ? ChatBottomPanelType.keyboard
          : ChatBottomPanelType.other,
      data: type,
    );
  }
}
