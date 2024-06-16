package com.fsa.chat_bottom_container

import FSAChatBottomContainerFlutterApi
import FSAChatBottomContainerHostApi
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ChatBottomContainerPlugin */
class ChatBottomContainerPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var hostApiImplementation: FSAChatBottomContainerHostApiImp
  private lateinit var flutterApi: FSAChatBottomContainerFlutterApi

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

      flutterApi = FSAChatBottomContainerFlutterApi(flutterPluginBinding.binaryMessenger)
      hostApiImplementation = FSAChatBottomContainerHostApiImp(flutterPluginBinding, flutterApi)

      FSAChatBottomContainerHostApi.setUp(
          flutterPluginBinding.binaryMessenger,
          hostApiImplementation,
      )
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }
}

class FSAChatBottomContainerHostApiImp(
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    private val flutterApi: FSAChatBottomContainerFlutterApi
) : FSAChatBottomContainerHostApi {
}
