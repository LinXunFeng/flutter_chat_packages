# 鸿蒙适配

本 fork 为 `chat_bottom_container 0.5.2` 增加 OpenHarmony / HarmonyOS 原生插件。
Android、iOS 和公共面板实现保持上游原样。Dart 仅新增鸿蒙高度通道的接收入口，
将高度转交给已有监听器，不改变面板 API、布局、动画和切换状态。

## 接入

使用支持 OHOS 的 Flutter SDK，并通过 Git 或本地 path 依赖本 fork 的
`packages/chat_bottom_container`。宿主应用还需要选择支持 OHOS 的
`shared_preferences` 实现；本插件不会覆盖宿主的依赖配置。
鸿蒙模块已声明 `@ohos/flutter_ohos`，其 `har/flutter.har` 由宿主 Flutter
工具链提供，避免完整应用采用严格依赖解析时找不到原生接口。

页面设置 `resizeToAvoidBottomInset: false`。输入栏下方放置
`ChatBottomPanelContainer`，让控制器统一管理键盘、表情、工具面板的切换和焦点。
如果外层已经处理底部安全区，传入 `safeAreaBottom: 0`，避免重复占位。

## 原生处理

- `ChatBottomContainerPlugin` 随 Flutter Engine 注册，并随 Ability 绑定窗口。
- 监听 `window.Window` 的 `keyboardHeightChange`，通过当前窗口 UIContext 的
  `px2vp` 把物理像素转换为逻辑像素。
- `chat_bottom_container/ohos` 通道把高度发给 Dart；整数与小数均转为 double，
  再复用已有键盘监听器。零表示收起，负值和非有限值被忽略。
- 窗口尚未创建时，在获得窗口焦点后重试绑定；异步取得窗口后检查绑定代次。
- Ability 或 Engine 分离时移除窗口监听与焦点监听，阻止过期异步结果重新注册。

系统高度通知用于记录键盘高度和识别收起；后续布局、动画和面板切换
完全复用上游实现。

## 验证

使用项目指定的 Flutter OHOS SDK 执行：

```sh
flutter pub get
flutter test test/chat_bottom_container_test.dart test/listener_manager_test.dart test/ohos_keyboard_test.dart
flutter analyze lib test/ohos_keyboard_test.dart
```

当前回归覆盖鸿蒙通道的整数、小数、零高度、无效数据过滤和取消监听，
以及原生高度转发到公共控制器、收起通知不关闭已切换的自定义面板。

原生模块此前使用 Flutter `3.44.9-ohos-0.0.1-canary1`、DevEco Studio
`26.0.0.851` 和 HarmonyOS SDK `26.0.0.105`（API 26）完成编译与自动注册，
完整宿主应用已签名并覆盖安装到 VDE-AL00（OpenHarmony-7.0.0.105）。

此前真机交互验证包含额外的公共面板改动；本 PR 已撤回这些改动，因此那次
交互结果不能作为当前上游原样面板的完整真机验收结论。当前版本需重新进行
键盘与自定义面板切换的真机验收。
