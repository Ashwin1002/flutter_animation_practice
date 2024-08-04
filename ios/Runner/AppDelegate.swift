import UIKit
import Flutter
// This is required for calling FlutterLocalNotificationsPlugin.setPluginRegistrantCallback method.
import flutter_local_notifications

import flutter_downloader

// class DeviceInfoApiImpl: NSObject, DeviceInfoApi {
//     func getDeviceInfo() -> DeviceInfo {
//         var deviceInfo = DeviceInfo()
//         deviceInfo.deviceModel = UIDevice.current.model
//         deviceInfo.deviceName = UIDevice.current.name // You can customize this for iOS
//         return deviceInfo
//     }
// }

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
    UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
      
      // let api = DeviceInfoApiImpl()
    //       DeviceInfoApiSetup.setUp(binaryMessenger: controller.binaryMessenger, api: api)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
