// import 'package:flutter_test/flutter_test.dart';
// import 'package:chat_bottom_container/chat_bottom_container.dart';
// import 'package:chat_bottom_container/chat_bottom_container_platform_interface.dart';
// import 'package:chat_bottom_container/chat_bottom_container_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockChatBottomContainerPlatform
//     with MockPlatformInterfaceMixin
//     implements ChatBottomContainerPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final ChatBottomContainerPlatform initialPlatform = ChatBottomContainerPlatform.instance;

//   test('$MethodChannelChatBottomContainer is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelChatBottomContainer>());
//   });

//   test('getPlatformVersion', () async {
//     ChatBottomContainer chatBottomContainerPlugin = ChatBottomContainer();
//     MockChatBottomContainerPlatform fakePlatform = MockChatBottomContainerPlatform();
//     ChatBottomContainerPlatform.instance = fakePlatform;

//     expect(await chatBottomContainerPlugin.getPlatformVersion(), '42');
//   });
// }
