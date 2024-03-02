import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/example/flutter_animation_practice/Messages.g.kt',
    kotlinOptions: KotlinOptions(),
    javaOut: 'android/app/src/main/java/io/flutter/plugins/Messages.java',
    javaOptions: JavaOptions(),
    swiftOut: 'ios/Runner/Messages.g.swift',
    swiftOptions: SwiftOptions(),
    dartPackageName: 'com.example.flutter_animation_practice',
  ),
)

// Define the data structure for device information
class DeviceInfo {
  String? deviceName;
  String? deviceModel;
}

// Define the API methods
@HostApi()
abstract class DeviceInfoApi {
  DeviceInfo getDeviceInfo();
}
