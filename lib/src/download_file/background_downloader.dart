import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

String downloderSendPort = 'downloader_send_port';

class BackgroundFileDownloader extends StatefulWidget {
  const BackgroundFileDownloader({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<BackgroundFileDownloader> createState() =>
      _BackgroundFileDownloaderState();
}

class _BackgroundFileDownloaderState extends State<BackgroundFileDownloader> {
  Future<Directory> get cacheDir => getTemporaryDirectory();
  List<DownloadTask>? _tasks;
  final ReceivePort _port = ReceivePort();

  void startDownload() async {
    final taskID = await FlutterDownloader.enqueue(
      url: widget.url,
      savedDir: (await cacheDir).absolute.path,
      showNotification: true,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(downloderSendPort);
  }

  void _bindBackgroundIsolate() {
    final isSuccess = IsolateNameServer.registerPortWithName(
      _port.sendPort,
      downloderSendPort,
    );

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen(
      (dynamic message) {
        var taskID = (message as List<dynamic>)[0] as String;
        var status = DownloadTaskStatus.fromInt(message[1] as int);
        var progress = message[2] as int;

        print(
          'Callback on UI isolate: '
          'task ($taskID) is in status ($status) and process ($progress)',
        );

        if (_tasks != null && (_tasks ?? []).isNotEmpty) {
          final task = _tasks!.firstWhere((task) => task.taskId == taskID);
          setState(() {
            task.copyWith(
              status: status,
              progress: progress,
            );
          });
        }
      },
    );
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
    String id,
    int status,
    int progress,
  ) {
    if (kDebugMode) {
      print(
        'Callback on background isolate: '
        'task ($id) is in status ($status) and process ($progress)',
      );
    }

    IsolateNameServer.lookupPortByName(downloderSendPort)
        ?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
