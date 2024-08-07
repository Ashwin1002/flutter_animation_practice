// Autogenerated from Pigeon (v17.1.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation

#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details,
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)",
  ]
}

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

/// Generated class from Pigeon that represents data sent in messages.
struct DeviceInfo {
  var deviceName: String? = nil
  var deviceModel: String? = nil

  static func fromList(_ list: [Any?]) -> DeviceInfo? {
    let deviceName: String? = nilOrValue(list[0])
    let deviceModel: String? = nilOrValue(list[1])

    return DeviceInfo(
      deviceName: deviceName,
      deviceModel: deviceModel
    )
  }
  func toList() -> [Any?] {
    return [
      deviceName,
      deviceModel,
    ]
  }
}
private class DeviceInfoApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
    case 128:
      return DeviceInfo.fromList(self.readValue() as! [Any?])
    default:
      return super.readValue(ofType: type)
    }
  }
}

private class DeviceInfoApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? DeviceInfo {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class DeviceInfoApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return DeviceInfoApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return DeviceInfoApiCodecWriter(data: data)
  }
}

class DeviceInfoApiCodec: FlutterStandardMessageCodec {
  static let shared = DeviceInfoApiCodec(readerWriter: DeviceInfoApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol DeviceInfoApi {
  func getDeviceInfo() throws -> DeviceInfo
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class DeviceInfoApiSetup {
  /// The codec used by DeviceInfoApi.
  static var codec: FlutterStandardMessageCodec { DeviceInfoApiCodec.shared }
  /// Sets up an instance of `DeviceInfoApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: DeviceInfoApi?) {
    let getDeviceInfoChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.com.example.flutter_animation_practice.DeviceInfoApi.getDeviceInfo", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      getDeviceInfoChannel.setMessageHandler { _, reply in
        do {
          let result = try api.getDeviceInfo()
          reply(wrapResult(result))
        } catch {
          reply(wrapError(error))
        }
      }
    } else {
      getDeviceInfoChannel.setMessageHandler(nil)
    }
  }
}
