package com.fsa.chat_bottom_container

import FSAChatBottomContainerFlutterApi
import FSAChatBottomContainerHostApi
import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ChatBottomContainerPlugin */
class ChatBottomContainerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
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

    // -------------- ActivityAware begin --------------
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        hostApiImplementation.onAttachedToActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }
    // -------------- ActivityAware end --------------
}

class FSAChatBottomContainerHostApiImp(
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    private val flutterApi: FSAChatBottomContainerFlutterApi
) : FSAChatBottomContainerHostApi {

    private val chatBottomContainerStub by lazy { ChatBottomContainerStub() }

    fun onAttachedToActivity(activity: Activity) {
        val decorView = activity.window.decorView
        chatBottomContainerStub.initialize(decorView, {}, {
            flutterApi.keyboardHeight(it.toDouble()) { }
        })
    }

}
