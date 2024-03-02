import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/utils/notification_utils.dart';

class LocalNotificationTestScreen extends StatefulWidget {
  const LocalNotificationTestScreen({super.key});

  @override
  State<LocalNotificationTestScreen> createState() =>
      _LocalNotificationTestScreenState();
}

class _LocalNotificationTestScreenState
    extends State<LocalNotificationTestScreen> {
  bool _isPermissionGranted = false;
  @override
  void initState() {
    super.initState();

    _checkPermission();
  }

  void _checkPermission() async {
    _isPermissionGranted = await NotificationUtils.requestPermission() ?? false;
    if (kDebugMode) {
      print('notification granted => $_isPermissionGranted');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (!_isPermissionGranted) {
                  return _checkPermission();
                }

                await NotificationUtils.showNotification();
              },
              child: const Text(
                'Simple Notification',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (!_isPermissionGranted) {
                  return _checkPermission();
                }

                await NotificationUtils.zonedScheduleNotification();
              },
              child: const Text(
                'Scheduled Notification',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
