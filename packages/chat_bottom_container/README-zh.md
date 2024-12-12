# chat_bottom_container

[![author](https://img.shields.io/badge/author-LinXunFeng-blue.svg?style=flat-square&logo=Iconify)](https://github.com/LinXunFeng/) [![author](https://img.shields.io/badge/author-GitLqr-blue.svg?style=flat-square&logo=Iconify)](https://github.com/GitLqr/) [![pub](https://img.shields.io/pub/v/chat_bottom_container?&style=flat-square&label=pub&logo=dart)](https://pub.dev/packages/chat_bottom_container)

Language: English | [中文](https://github.com/LinXunFeng/flutter_chat_packages/blob/main/packages/chat_bottom_container)

这是一个用来管理聊天页底部视图容器的Flutter组件库，可用来实现丝滑切换键盘与其它面板的功能。

微信技术交流群请看: [【微信群说明】](https://mp.weixin.qq.com/s/JBbMstn0qW6M71hh-BRKzw)

## ☕ 请我喝一杯咖啡

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/T6T4JKVRP)

两位核心作者的微信收款码，感谢支持！

|[LinXunFeng](https://github.com/LinXunFeng)|[GitLqr](https://github.com/GitLqr)|
|-|-|
|<img height="272" width="200" src="https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20220417121922/image/202303181116760.jpeg"/>|<img height="272" width="200" src="https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202406172130257.jpg"/>|

## 📖 文章

- [Flutter - 实现聊天键盘与功能面板的丝滑切换 🍻](https://mp.weixin.qq.com/s/FC67AhlVQlYRvj3a5VcyHQ) | [备用链接](https://juejin.cn/post/7383258697470476338)
- [Flutter - 聊天键盘与面板丝滑切换的强势升级 🍻](https://mp.weixin.qq.com/s/fy5lUi1qeaZlZXcdF66OxQ) | [备用链接](https://juejin.cn/post/7399045497002328102)

## 🎀 支持
- iOS
- Android

## 📦 安装

在你的 `pubspec.yaml` 文件中添加 `chat_bottom_container` 依赖:

```yaml
dependencies:
  chat_bottom_container: latest_version
```

在需要使用的地方导入 `chat_bottom_container` :

```dart
import 'package:chat_bottom_container/chat_bottom_container.dart';
```

### 🤖 Android

添加 `jitpack` 仓库到你的项目根目录下的 `build.gradle` 文件中:

```gradle
allprojects {
  repositories {
    ...
    maven { url 'https://jitpack.io' }
  }
}
```

## 🚀 使用

![](https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202406172255393.gif)

整体页面布局

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    // 设置为 false
    resizeToAvoidBottomInset: false,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            ...
          ),
        ),
        // 输入框视图
        _buildInputView(),
        // 底部容器
        _buildPanelContainer(),
      ],
    ),
  );
}
```

底部视图

```dart
/// 自定义底部面板类型
enum PanelType {
  none,
  keyboard,
  emoji,
  tool,
}

final controller = ChatBottomPanelContainerController<PanelType>();
final FocusNode inputFocusNode = FocusNode();
PanelType currentPanelType = PanelType.none;

Widget _buildPanelContainer() {
  return ChatBottomPanelContainer<PanelType>(
    controller: controller,
    inputFocusNode: inputFocusNode,
    otherPanelWidget: (type) {
      // 返回自定义的面板视图
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
      // 记录当前的面板类型
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
```

切换底部面板类型

```dart
controller.updatePanelType(
  // 设置 ChatBottomPanelContainer 当前的底部面板类型
  // 可传入 ChatBottomPanelType.keyboard | ChatBottomPanelType.other | ChatBottomPanelType.none
  ChatBottomPanelType.other,
  // 外部开发者自定义的 PanelType 类型，当 ChatBottomPanelType.other 时必传
  data: PanelType.emoji, // PanelType.tool
);
```

---

<details>
  <summary>下面再提供一些额外的功能与说明</summary>

### 隐藏面板

```dart
hidePanel() {
  inputFocusNode.unfocus();
  if (ChatBottomPanelType.none == controller.currentPanelType) return;
  controller.updatePanelType(ChatBottomPanelType.none);
}
```

### 自定义底部安全区高度

在默认情况下，`chat_bottom_container` 会自动帮你添加底部安全区高度，但在一些场景下你可能不希望如此，那你可以通过将 `safeAreaBottom` 设置为 `0` 来自定义这个高度。

```dart
return ChatBottomPanelContainer<PanelType>(
  ...
  safeAreaBottom: 0,
  ...
);
```

### 调整键盘面板高度

如示例中位于首页的聊天页面，需要减去外层底部固定的 `BottomNavigationBar` 高度

```dart
return ChatBottomPanelContainer<PanelType>(
  ...
  changeKeyboardPanelHeight: (keyboardHeight) {
    final renderObj = bottomNavigationBarKey.currentContext?.findRenderObject();
    if (renderObj is! RenderBox) return keyboardHeight;
    return keyboardHeight - renderObj.size.height;
  },
  ...
);
```

</details>

## 🖨 关于我

- GitHub: [https://github.com/LinXunFeng](https://github.com/LinXunFeng)
- Email: [linxunfeng@yeah.net](mailto:linxunfeng@yeah.net)
- Blogs: 
  - 全栈行动: [https://fullstackaction.com](https://fullstackaction.com)
  - 掘金: [https://juejin.cn/user/1820446984512392](https://juejin.cn/user/1820446984512392) 

<img height="267.5" width="481.5" src="https://github.com/LinXunFeng/LinXunFeng/raw/master/static/img/FSAQR.png"/>
