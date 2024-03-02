package com.example.flutter_animation_practice

import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

private class DeviceInfoApiImpl : Messages.DeviceInfoApi {
    override fun getDeviceInfo(): Messages.DeviceInfo {
        val deviceInfo = Messages.DeviceInfo()
        deviceInfo.deviceModel = Build.MODEL
        deviceInfo.deviceName = Build.USER
        return deviceInfo
    }
}

class MainActivity: FlutterActivity() {
    override  fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val api = DeviceInfoApiImpl()
        Messages.DeviceInfoApi.setUp(flutterEngine.dartExecutor.binaryMessenger, api);
    }
}