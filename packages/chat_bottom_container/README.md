# chat_bottom_container

[![author](https://img.shields.io/badge/author-LinXunFeng-blue.svg?style=flat-square&logo=Iconify)](https://github.com/LinXunFeng/) [![author](https://img.shields.io/badge/author-GitLqr-blue.svg?style=flat-square&logo=Iconify)](https://github.com/GitLqr/) [![pub](https://img.shields.io/pub/v/chat_bottom_container?&style=flat-square&label=pub&logo=dart)](https://pub.dev/packages/chat_bottom_container)

Language: English | [中文](https://github.com/LinXunFeng/flutter_chat_packages/blob/main/packages/chat_bottom_container/README-zh.md)

This is a Flutter package for managing the bottom container of a chat page, which can be used to implement smooth switching between the keyboard and the other panel.

Chat: [Join WeChat group](https://mp.weixin.qq.com/s/JBbMstn0qW6M71hh-BRKzw)


## ☕ Support me

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/T6T4JKVRP)

The WeChat payment QR codes of the two core authors, thank you for your support!

|[LinXunFeng](https://github.com/LinXunFeng)|[GitLqr](https://github.com/GitLqr)|
|-|-|
|<img height="272" width="200" src="https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20220417121922/image/202303181116760.jpeg"/>|<img height="272" width="200" src="https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202406172130257.jpg"/>|

## 📖 Article

- [Flutter - Smooth switching between chat keyboard and panel](https://medium.com/@linxunfeng/flutter-smooth-switching-between-chat-keyboard-and-panel-8b921d5f52a8) | [WeChat](https://mp.weixin.qq.com/s/FC67AhlVQlYRvj3a5VcyHQ) | [JueJin](https://juejin.cn/post/7383258697470476338)
- [Flutter - A powerful upgrade for smooth switching between chat keyboard and panel](https://medium.com/@linxunfeng/flutter-a-powerful-upgrade-for-smooth-switching-between-chat-keyboard-and-panel-08ebb2f5e57a) | [WeChat](https://mp.weixin.qq.com/s/fy5lUi1qeaZlZXcdF66OxQ) | [JueJin](https://juejin.cn/post/7399045497002328102)

## 🎀 Support
- iOS
- Android

## 📦 Installing

Add `chat_bottom_container` to your pubspec.yaml file:


```yaml
dependencies:
  chat_bottom_container: latest_version
```

Import `chat_bottom_container` in files that it will be used:

```dart
import 'package:chat_bottom_container/chat_bottom_container.dart';
```

### 🤖 Android

Add `jitpack` to the root `build.gradle` file of your project at the end of repositories.

```gradle
allprojects {
  repositories {
    ...
    maven { url 'https://jitpack.io' }
  }
}
```

## 🚀 Usage

![](https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202406172255393.gif)

Overall page layout.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    // Need to be set to false
    resizeToAvoidBottomInset: false,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ListView.builder(
            ...
          ),
        ),
        // Input box view
        _buildInputView(),
        // Bottom container
        _buildPanelContainer(),
      ],
    ),
  );
}
```

Bottom container.

```dart
/// Custom bottom panel type
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
      // Return the custom panel view
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
      // Record the current panel type
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

Toggle bottom panel type.

```dart
controller.updatePanelType(
  // Set the current bottom panel type of ChatBottomPanelContainer
  // Can be passed to ChatBottomPanelType.keyboard | ChatBottomPanelType.other | ChatBottomPanelType.none
  ChatBottomPanelType.other,
  // Callback the PanelType value customized by developer, must be passed when ChatBottomPanelType.other
  data: PanelType.emoji, // PanelType.tool
);
```

---

<details>
  <summary>Here are some additional features and instructions</summary>

### Hide Panel

```dart
hidePanel() {
  inputFocusNode.unfocus();
  if (ChatBottomPanelType.none == controller.currentPanelType) return;
  controller.updatePanelType(ChatBottomPanelType.none);
}
```

### Customize bottom safe area height

By default, `chat_bottom_container` will automatically add the bottom safe area height for you, but in some scenarios you may not want this, you can customize this height by setting `safeAreaBottom` to `0`.

```dart
return ChatBottomPanelContainer<PanelType>(
  ...
  safeAreaBottom: 0,
  ...
);
```

### Adjust the keyboard panel height

For example, in the chat page on the home page, the height of the fixed `BottomNavigationBar` at the bottom of the outer layer needs to be subtracted.

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

### Animation effect

You can customize the animation effect by using the `customPanelContainer`. Here are some examples:

|Fade|
|-|
|![](https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202507072319859.gif)|


|Cube|
|-|
|![](https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202507072320480.gif)|

|Concentric|
|-|
|![](https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202507072321326.gif)|

|Rotation|
|-|
|![](https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202507072321811.gif)|

|ZoomIn|
|-|
|![](https://cdn.jsdelivr.net/gh/FullStackAction/PicBed@resource20230813121546/image/202507072321995.gif)|

## 🖨 About Me

- GitHub: [https://github.com/LinXunFeng](https://github.com/LinXunFeng)
- Email: [linxunfeng@yeah.net](mailto:linxunfeng@yeah.net)
- Blogs: 
  - 全栈行动: [https://fullstackaction.com](https://fullstackaction.com)
  - 掘金: [https://juejin.cn/user/1820446984512392](https://juejin.cn/user/1820446984512392) 

<img height="267.5" width="481.5" src="https://github.com/LinXunFeng/LinXunFeng/raw/master/static/img/FSAQR.png"/>