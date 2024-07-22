import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/src/download_file/widgets/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Future<Directory> get cacheDir => getApplicationDocumentsDirectory();

  final ReceivePort _port = ReceivePort();

  String? _taskID;
  DownloadTaskStatus? _downloadTaskStatus;
  int _progress = 0;
  late bool _showContent;
  late bool _isPermissionReady;
  late String _localPath;

  void startDownload() async {
    await FlutterDownloader.enqueue(
      url: widget.url,
      savedDir: _localPath,
      saveInPublicStorage: false,
      showNotification: false,
      fileName: widget.url.split('/').last,
      openFileFromNotification: false,
    );
  }

  void pauseDownload() async {
    if (_taskID == null) return;
    await FlutterDownloader.pause(taskId: _taskID!);
  }

  void resumeDownload() async {
    if (_taskID == null) return;
    final taskID = await FlutterDownloader.resume(taskId: _taskID!);
    setState(() {
      _taskID = taskID;
    });
  }

  void removeDownload() async {
    if (_taskID == null) return;
    await FlutterDownloader.remove(taskId: _taskID!);
    await _prepare();
  }

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    _showContent = false;
    _isPermissionReady = false;

    _prepare();
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
        if (status == DownloadTaskStatus.failed) {
          startDownload();
        }

        setState(() {
          _taskID = taskID;
          _progress = progress;
          _downloadTaskStatus = status;
        });
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

  Future<void> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();

    if (tasks == null) return;

    log('tasks => $tasks');
    if (tasks.isNotEmpty) {
      for (var task in tasks) {
        // if (task.status == DownloadTaskStatus.failed) {
        //   await FlutterDownloader.remove(taskId: task.taskId);
        // }
        if (task.url == widget.url) {
          if (!mounted) return;
          setState(() {
            _taskID = task.taskId;
            _progress = task.progress;
            _downloadTaskStatus = task.status;
          });
        }
      }
    }

    _isPermissionReady = await _checkPermission();
    if (_isPermissionReady) {
      _localPath = (await cacheDir).absolute.path;
      final savedDir = Directory(_localPath);
      if (!savedDir.existsSync()) {
        await savedDir.create();
      }
    }

    setState(() {
      _showContent = true;
    });
  }

  Future<bool> _checkPermission() async {
    final isStoragePermissonGranted = await Permission.storage.isGranted;

    final requestStoragePermission = await Permission.storage.request();
    final isStorageRequestedPermissonGranted =
        requestStoragePermission == PermissionStatus.granted;

    final isIOS = Platform.isIOS;
    final isAndroid = Platform.isAndroid;

    return (isIOS ||
        (isAndroid &&
                (await DeviceInfoPlugin().androidInfo).version.sdkInt > 28 ||
            isStoragePermissonGranted ||
            isStorageRequestedPermissonGranted));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const FilePreview(),
            const SizedBox(width: 20.0),
            const FileContent(),
            const SizedBox(width: 20.0),
            if (!_showContent)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              switch (_downloadTaskStatus) {
                DownloadTaskStatus.complete => DownloadedButton(
                    onTap: () => removeDownload(),
                  ),
                DownloadTaskStatus.paused => DownloadingButton(
                    isPaused: true,
                    value: _progress / 100,
                    onTap: () => resumeDownload(),
                  ),
                DownloadTaskStatus.running => DownloadingButton(
                    value: _progress / 100,
                    onTap: () => pauseDownload(),
                  ),
                _ => DownloadButton(
                    onTap: () => startDownload(),
                  ),
              }
          ],
        ),
      ),
    );
  }
}
