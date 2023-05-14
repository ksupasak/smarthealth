package com.example.smart_health

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object NativeMethodChannel {
    private const val CHANNEL_NAME = "channel"
    private lateinit var methodChannel: MethodChannel

    fun configureChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
    }


    // add the following method, it passes a string to flutter
    fun showNewIdea(idea: String) {
        methodChannel.invokeMethod("showNewIdea", idea)
    }
}