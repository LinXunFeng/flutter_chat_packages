# 鸿蒙适配

`chat_bottom_container` 支持 OpenHarmony / HarmonyOS。原生端只负责监听键盘高度，
面板的布局、动画和切换逻辑与 Android / iOS 共用同一套 Dart 实现，API 没有区别。

## 接入

1. 使用支持 OHOS 的 Flutter SDK。
2. 添加依赖：

   ```sh
   flutter pub add chat_bottom_container
   ```

3. 本插件依赖 `shared_preferences`，宿主需要接入支持 OHOS 的 `shared_preferences` 实现。
4. 其余用法与 [README](../README-zh.md) 一致：页面设置 `resizeToAvoidBottomInset: false`，
   在输入栏下方放置 `ChatBottomPanelContainer`。如果外层已经处理底部安全区，
   传入 `safeAreaBottom: 0`，避免重复占位。

## 实现说明

- 插件通过当前 Ability 的 `WindowStage.getMainWindow()` 绑定主窗口，
  监听 `keyboardHeightChange`，并用该窗口的 `px2vp` 将物理像素转换为逻辑像素。
- 高度经 `chat_bottom_container/ohos` 通道发送到 Dart，交给已有的键盘监听器处理。
  `0` 表示键盘收起，负值和非有限值会被忽略。
- 窗口尚未创建时，会在窗口获得焦点后重试绑定。
- Ability 或 Engine 分离时移除所有监听。
