package com.publicis.ys_shumei_flutter

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** YsShumeiFlutterPlugin */
class YsShumeiFlutterPlugin : FlutterPlugin {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
//    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
//        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ys_shumei_flutter")
//        channel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger,"sample.flutter.io/test_event_channel")

        val messger: BinaryMessenger = flutterPluginBinding.binaryMessenger
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "sample_view",
            MyFlutterViewFactory(messger)
        )

    }

    /*override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }*/

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
//        channel.setMethodCallHandler(null)
    }
}
