/*
 * @Author: LinXunFeng linxunfeng@yeah.net
 * @Repo: https://github.com/LinXunFeng/flutter_chat_packages
 * @Date: 2024-06-15 17:48:05
 */

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:chat_bottom_container_example/chat_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class App {
  static final routeObserver = RouteObserver<ModalRoute>();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        App.routeObserver,
      ],
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final bottomNavigationBarKey = GlobalKey();

  var _keepPanel = false;
  ChatBottomPanelContainerController? controller;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Chat Bottom Container Example'),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Widget resultWidget = TabBarView(
      controller: _tabController,
      children: [
        ChatPage(
          safeAreaBottom: 0,
          showAppBar: false,
          keepPanel: _keepPanel,
          changeKeyboardPanelHeight: (keyboardHeight) {
            // Here we need to subtract the height of BottomNavigationBar.
            final renderObj =
                bottomNavigationBarKey.currentContext?.findRenderObject();
            if (renderObj is! RenderBox) return keyboardHeight;
            return keyboardHeight - renderObj.size.height;
          },
          onControllerCreated: (controller) {
            this.controller = controller;
          },
        ),
        Container(color: Colors.red),
        Container(color: Colors.blue),
      ],
    );
    resultWidget = Stack(
      children: [
        resultWidget,
        Positioned(right: 10, child: _buildFloatingView()),
      ],
    );
    return resultWidget;
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      key: bottomNavigationBarKey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'People',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildFloatingView() {
    Widget resultWidget = Column(
      children: [
        _buildFloatingBtn(
          icon: Icons.chevron_right_sharp,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const ChatPage();
                },
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildFloatingBtn(
          icon: Icons.keyboard_arrow_up_sharp,
          onPressed: () async {
            if (_keepPanel) {
              controller?.keepChatPanel();
            }
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return const FractionallySizedBox(
                  heightFactor: 0.8,
                  child: ChatPage(),
                );
              },
            );
            if (_keepPanel) {
              controller?.restoreChatPanel();
            }
          },
        ),
        const SizedBox(height: 10),
        _buildFloatingBtn(
          icon: _keepPanel ? Icons.keyboard : Icons.crop_landscape,
          onPressed: () {
            setState(() {
              _keepPanel = !_keepPanel;
            });
          },
        ),
      ],
    );
    return resultWidget;
  }

  Widget _buildFloatingBtn({
    required void Function()? onPressed,
    IconData? icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        shadowColor: Colors.grey[50],
        elevation: 2,
      ),
      child: Icon(icon),
    );
  }
}
