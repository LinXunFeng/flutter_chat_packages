import 'package:pigeon/pigeon.dart';

// https://github.com/flutter/packages/blob/main/packages/pigeon/example/README.md
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/plugin/pigeon.g.dart',
  kotlinOut:
      'android/src/main/kotlin/com/fsa/chat_bottom_container/ChatBottomContainerGeneratedApis.g.kt',
  kotlinOptions: KotlinOptions(
    // https://github.com/fluttercommunity/wakelock_plus/issues/18
    errorClassName: "FSAChatBottomContainerFlutterError",
  ),
  swiftOut: 'ios/Classes/FSAChatBottomContainerGeneratedApis.g.swift',
))
@HostApi()
abstract class FSAChatBottomContainerHostApi {}

@FlutterApi()
abstract class FSAChatBottomContainerFlutterApi {
  void keyboardHeight(double height);
}
