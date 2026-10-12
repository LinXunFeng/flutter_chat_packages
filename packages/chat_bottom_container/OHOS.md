# 鸿蒙适配

本 fork 为 `chat_bottom_container 0.5.2` 增加 OpenHarmony / HarmonyOS 原生插件。
Android、iOS 保留原有实现，三个平台共用 Dart 面板控制器。

## 接入

使用支持 OHOS 的 Flutter SDK，并通过 Git 或本地 path 依赖本 fork 的
`packages/chat_bottom_container`。宿主应用还需要选择支持 OHOS 的
`shared_preferences` 实现；本插件不会覆盖宿主的依赖配置。
鸿蒙模块已声明 `@ohos/flutter_ohos`，其 `har/flutter.har` 由宿主 Flutter
工具链提供，避免完整应用采用严格依赖解析时找不到原生接口。

页面设置 `resizeToAvoidBottomInset: false`。输入栏下方放置
`ChatBottomPanelContainer`，让控制器统一管理键盘、表情、工具面板的切换和焦点。
如果外层已经处理底部安全区，传入 `safeAreaBottom: 0`，避免重复占位。

新增 `defaultKeyboardHeight` 参数（默认 300），用于尚未记录键盘高度时，
从自定义面板切回键盘的占位。建议与首次自定义面板高度一致。

## 原生处理

- `ChatBottomContainerPlugin` 随 Flutter Engine 注册，并随 Ability 绑定窗口。
- 监听 `window.Window` 的 `keyboardHeightChange`，通过当前窗口 UIContext 的
  `px2vp` 把物理像素转换为逻辑像素。
- `chat_bottom_container/ohos` 通道把高度发给 Dart；整数与小数均转为 double，
  再复用已有键盘监听器。零表示收起，负值和非有限值被忽略。
- 窗口尚未创建时，在获得窗口焦点后重试绑定；异步取得窗口后检查绑定代次。
- Ability 或 Engine 分离时移除窗口监听与焦点监听，阻止过期异步结果重新注册。

系统高度通知用于记录键盘高度和识别收起；动画中的布局仍跟随 Flutter
`viewInsets`。不把最终高度事件当成逐帧动画事件，也不再给键盘高度叠加
`AnimatedSize` 动画。自定义面板的展开仍保留动画。

## 验证

使用项目指定的 Flutter OHOS SDK 执行：

```sh
flutter pub get
flutter test test/chat_bottom_container_test.dart test/listener_manager_test.dart test/ohos_keyboard_test.dart
flutter analyze lib test/ohos_keyboard_test.dart
```

本次使用 Flutter `3.44.9-ohos-0.0.1-canary1` 和 HarmonyOS API 26 工具链，
在独立 Flutter OHOS 工程和完整宿主应用中验证了 ArkTS 编译、自动插件注册，
并完成完整宿主应用的签名 HAP 生成。
2026-10-12 使用 DevEco 更新宿主调试签名后，在 VDE-AL00
（OpenHarmony-7.0.0.105）完成安装与真机交互检查。使用完整宿主的真实聊天组件，
消息接口和数据库使用独立调试入口的本地模拟数据。

已验证首次表情面板切回键盘、键盘与表情及更多面板三轮互切、系统返回收键盘、
三键导航与无三键导航两种布局，以及退出聊天后重新进入。
系统输入法连续发送后键盘保持展开，输入框清空并能继续输入；
原生高度已传到 Dart，当前设备竖屏记录为约 300.33 逻辑像素。
上述交互未记录到 Flutter 异常，最终布局未发现操作区被遮挡或残留空白。

仍需覆盖不同输入法、横竖屏及折叠态变化；本轮没有进行逐帧动画性能测量，
不以截图或调试模式交互结果宣称所有设备的帧率表现。
