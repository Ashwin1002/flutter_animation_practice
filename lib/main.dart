import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/messages.g.dart';
import 'package:flutter_animation_practice/src/main/main_page.dart';
import 'package:flutter_animation_practice/utils/notification_utils.dart';
import 'package:flutter_animation_practice/utils/timezonr_utils.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    configureLocalTimeZone(),
    NotificationUtils.initializeNotification(),
    NotificationUtils.requestPermission(),
    FlutterDownloader.initialize(debug: true)
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getDeviceModel();
  }

  void getDeviceModel() async {
    DeviceInfo deviceInfo = DeviceInfo();

    final deviceInfoApi = DeviceInfoApi();
    deviceInfo = await deviceInfoApi.getDeviceInfo();

    log('device name => ${deviceInfo.deviceModel}');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
