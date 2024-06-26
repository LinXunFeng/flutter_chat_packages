// Autogenerated from Pigeon (v17.3.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

private func createConnectionError(withChannelName channelName: String) -> FlutterError {
  return FlutterError(code: "channel-error", message: "Unable to establish connection on channel: '\(channelName)'.", details: "")
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}
/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol FSAChatBottomContainerHostApi {
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class FSAChatBottomContainerHostApiSetup {
  /// The codec used by FSAChatBottomContainerHostApi.
  /// Sets up an instance of `FSAChatBottomContainerHostApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: FSAChatBottomContainerHostApi?) {
  }
}
/// Generated protocol from Pigeon that represents Flutter messages that can be called from Swift.
protocol FSAChatBottomContainerFlutterApiProtocol {
  func keyboardHeight(height heightArg: Double, completion: @escaping (Result<Void, FlutterError>) -> Void)
}
class FSAChatBottomContainerFlutterApi: FSAChatBottomContainerFlutterApiProtocol {
  private let binaryMessenger: FlutterBinaryMessenger
  init(binaryMessenger: FlutterBinaryMessenger) {
    self.binaryMessenger = binaryMessenger
  }
  func keyboardHeight(height heightArg: Double, completion: @escaping (Result<Void, FlutterError>) -> Void) {
    let channelName: String = "dev.flutter.pigeon.chat_bottom_container.FSAChatBottomContainerFlutterApi.keyboardHeight"
    let channel = FlutterBasicMessageChannel(name: channelName, binaryMessenger: binaryMessenger)
    channel.sendMessage([heightArg] as [Any?]) { response in
      guard let listResponse = response as? [Any?] else {
        completion(.failure(createConnectionError(withChannelName: channelName)))
        return
      }
      if listResponse.count > 1 {
        let code: String = listResponse[0] as! String
        let message: String? = nilOrValue(listResponse[1])
        let details: String? = nilOrValue(listResponse[2])
        completion(.failure(FlutterError(code: code, message: message, details: details)))
      } else {
        completion(.success(Void()))
      }
    }
  }
}
