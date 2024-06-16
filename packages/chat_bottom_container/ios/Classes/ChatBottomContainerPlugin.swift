import Flutter
import UIKit
import FSAChatBottomContainer

public class ChatBottomContainerPlugin: NSObject, FlutterPlugin {
  static var hostApi: FSAChatBottomContainerHostApiImp?
  static var flutterApi: FSAChatBottomContainerFlutterApi?

  public static func register(with registrar: FlutterPluginRegistrar) {
    hostApi = FSAChatBottomContainerHostApiImp()
    FSAChatBottomContainerHostApiSetup.setUp(
      binaryMessenger: registrar.messenger(), 
      api: hostApi
    )
    
    flutterApi = FSAChatBottomContainerFlutterApi(binaryMessenger: registrar.messenger())
  }
}

// https://github.com/flutter/flutter/issues/136081
extension FlutterError: Error {}

class FSAChatBottomContainerHostApiImp: FSAChatBottomContainerHostApi {
  var imp: FSAChatBottomContainer?
  
  init() {
    imp = FSAChatBottomContainer(keyboardHeightBlock: { height in
      ChatBottomContainerPlugin.flutterApi?.keyboardHeight(height: height, completion: { _ in })
    })
  }
}