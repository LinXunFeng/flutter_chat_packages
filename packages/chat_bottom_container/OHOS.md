# 鸿蒙适配

`chat_bottom_container` 提供 OpenHarmony / HarmonyOS 原生键盘高度监听。
Android、iOS 和公共面板实现保持上游原样。Dart 仅新增鸿蒙高度通道的接收入口，
将高度转交给已有监听器，不改变面板 API、布局、动画和切换状态。

## 接入

使用支持 OHOS 的 Flutter SDK，通过 pub 添加包含鸿蒙支持的已发布版本：

```sh
flutter pub add chat_bottom_container
```

鸿蒙支持需使用包含本次适配的正式版本，具体以 pub.dev 发布记录为准。
宿主应用还需要选择支持 OHOS 的
`shared_preferences` 实现；本插件不会覆盖宿主的依赖配置。
鸿蒙模块已声明 `@ohos/flutter_ohos`，其 `har/flutter.har` 由宿主 Flutter
工具链提供，避免完整应用采用严格依赖解析时找不到原生接口。

页面设置 `resizeToAvoidBottomInset: false`。输入栏下方放置
`ChatBottomPanelContainer`，让控制器统一管理键盘、表情、工具面板的切换和焦点。
如果外层已经处理底部安全区，传入 `safeAreaBottom: 0`，避免重复占位。

## 原生处理

- `ChatBottomContainerPlugin` 随 Flutter Engine 注册，通过当前 Ability 的
  `WindowStage.getMainWindow()` 绑定主窗口，避免绑定到最上层子窗口。
- 监听 `window.Window` 的 `keyboardHeightChange`，通过当前窗口 UIContext 的
  `px2vp` 把物理像素转换为逻辑像素。
- `chat_bottom_container/ohos` 通道把高度发给 Dart；整数与小数均转为 double，
  再复用已有键盘监听器。零表示收起，负值和非有限值被忽略。
- 窗口尚未创建时，在获得窗口焦点后重试绑定；异步取得窗口后检查绑定代次。
- Ability 或 Engine 分离时移除窗口监听与焦点监听，阻止过期异步结果重新注册。

系统高度通知用于记录键盘高度和识别收起；后续布局、动画和面板切换
完全复用上游实现。

## 原生模块版本

`ohos/oh-package.json5` 的 `version` 是 OHPM/HAR 的模块版本元数据，
工具链会读取它。Flutter OHOS 通过本地源码或 HAR 路径引入插件，不用这个字段
选择 pub 版本；但该字段也不会自动跟随 `pubspec.yaml` 更新。
发布流程应在 melos 更新 Dart 包版本后、打包发布前，将此字段同步为相同版本。
详见 [华为模块配置说明](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-hmos-oh-package-json5)。

## 验证

使用项目指定的 Flutter OHOS SDK 执行：

```sh
flutter pub get
flutter test test/chat_bottom_container_test.dart test/listener_manager_test.dart test/ohos_keyboard_test.dart
flutter analyze lib test/ohos_keyboard_test.dart
```

当前回归覆盖鸿蒙通道的整数、小数、零高度、无效数据过滤和取消监听，
以及原生高度转发到公共控制器、收起通知不关闭已切换的自定义面板。

本次使用 Flutter `3.44.9-ohos-0.0.1-canary1`、DevEco Studio
`26.0.0.851` 和 HarmonyOS SDK `26.0.0.105`（API 26），在
VDE-AL00（OpenHarmony-7.0.0.105）完成编译、自动注册和竖屏真机验收。

验收运行仓库自带的 `example/lib/main.dart`：由于示例未提供 OHOS 宿主，
将原示例的全部 Dart 文件原样复制到临时 OHOS 宿主，仅配置本地插件依赖、
支持 OHOS 的 `shared_preferences` 和调试签名。未修改示例交互或公共面板实现。

竖屏下依次完成「弹出键盘 → 切到 Emoji Panel → 切回键盘 → 收起」，
输入栏保持可见，自定义面板正常占位，收起后无残留底部占位。
录屏附在对应 PR。横屏尚未完成本次原示例验收，不在已验证范围内。
