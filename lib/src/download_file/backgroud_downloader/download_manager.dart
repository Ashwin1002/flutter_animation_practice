import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animation_practice/src/download_file/backgroud_downloader/download_status.dart';
import 'package:flutter_animation_practice/src/download_file/backgroud_downloader/download_task.dart';
import 'package:flutter_animation_practice/src/download_file/backgroud_downloader/request.dart';

class DownloadManager {
  final Map<String, DownloadListener> _cache = <String, DownloadListener>{};
  final Queue<Request> _queue = Queue();

  Dio _dio = Dio();

  static const partialExtension = '.partial';
  static const tempExtension = '.temp';

  int maxConcurrentTasks = 2;
  int runningTasks = 0;

  DownloadManager._();

  static final DownloadManager _manager = DownloadManager._();

  factory DownloadManager({
    int? maxConcurrentTasks,
    Dio? dio,
  }) {
    if (maxConcurrentTasks != null) {
      _manager.maxConcurrentTasks = maxConcurrentTasks;
    }

    _manager._dio = dio ?? Dio();

    return _manager;
  }

  void Function(int recieved, int total) createCallback(
    url,
    int partialFileLength,
  ) {
    return (int received, int total) {
      getDownload(url)?.progress.value =
          (received + partialFileLength) / (total + partialFileLength);

      if (total == -1) {}
    };
  }

  // Do not immediately call getDownload After addDownload, rather use the returned DownloadListener from addDownload
  DownloadListener? getDownload(String url) => _cache[url];

  void setStatus(DownloadListener? task, DownloadStatus status) {
    if (task != null) {
      task.status.value = status;
      if (status.isCompleted) {
        // disposeNotifiers(task);
      }
    }
  }

  void _startExecution() async {
    if (runningTasks == maxConcurrentTasks || _queue.isEmpty) {
      return;
    }

    while (_queue.isNotEmpty && runningTasks < maxConcurrentTasks) {
      runningTasks++;

      _logPrint('Concurrent workers: $runningTasks');

      var currentRequest = _queue.removeFirst();

      await download(
        url: currentRequest.url,
        savePath: currentRequest.path,
        cancelToken: currentRequest.cancelToken,
      );

      await Future.delayed(const Duration(milliseconds: 500), null);
    }
  }

  Future<void> download({
    required String url,
    required String savePath,
    bool forceDownload = false,
    CancelToken? cancelToken,
  }) async {
    late String partialFilePath;
    late File partialFile;

    try {
      var task = getDownload(url);
      if (task == null || task.status.value.isCancelled) return;

      setStatus(task, DownloadStatus.downloading);

      _logPrint('Download URL => $url');

      var file = File(savePath.toString());
      partialFilePath = savePath + partialExtension;
      partialFile = File(partialFilePath);

      var fileExist = await file.exists();
      var partialFileExist = await partialFile.exists();

      if (fileExist) {
        _logPrint('File Exist');
        setStatus(task, DownloadStatus.completed);
      } else if (partialFileExist) {
        _logPrint('Partially File Downloaded');

        var partialFileLength = await partialFile.length();

        var response = await _dio.download(
          url,
          partialFilePath + tempExtension,
          onReceiveProgress: createCallback(url, partialFileLength),
          options: Options(
            headers: {HttpHeaders.rangeHeader: 'bytes=$partialFileLength-'},
          ),
          cancelToken: cancelToken,
          deleteOnError: true,
        );

        if (response.statusCode == HttpStatus.partialContent) {
          var ioSink = partialFile.openWrite(mode: FileMode.writeOnlyAppend);
          var f = File(partialFilePath + tempExtension);
          await ioSink.addStream(f.openRead());
          await f.delete();
          await ioSink.close();
          await partialFile.rename(savePath);

          setStatus(task, DownloadStatus.completed);
        }
      } else {
        var response = await _dio.download(
          url,
          partialFilePath,
          onReceiveProgress: createCallback(url, 0),
          cancelToken: cancelToken,
          deleteOnError: false,
        );

        if (response.statusCode == HttpStatus.ok) {
          await partialFile.rename(savePath);
          setStatus(task, DownloadStatus.completed);
        }
      }
    } catch (e) {
      var task = getDownload(url)!;
      if (!task.status.value.isCancelled && !task.status.value.isPaused) {
        setStatus(task, DownloadStatus.failed);
        runningTasks--;

        if (_queue.isNotEmpty) {
          _startExecution();
        }
        rethrow;
      } else if (task.status.value == DownloadStatus.paused) {
        final ioSink = partialFile.openWrite(mode: FileMode.writeOnlyAppend);
        final f = File(partialFilePath + tempExtension);
        if (await f.exists()) {
          await ioSink.addStream(f.openRead());
        }
        await ioSink.close();
      }

      runningTasks--;

      if (_queue.isNotEmpty) {
        _startExecution();
      }
    }
  }

  // Future<DownloadListener?> addDownload(String url, String savedDir) async {
  //   if (url.isNotEmpty) {
  //     if (savedDir.isEmpty) {
  //       savedDir = ".";
  //     }

  //     var isDirectory = await Directory(savedDir).exists();
  //     var downloadFilename = isDirectory
  //         ? savedDir + Platform.pathSeparator + getFileNameFromUrl(url)
  //         : savedDir;

  //     return _addDownloadRequest(DownloadRequest(url, downloadFilename));
  //   }
  //   return null;
  // }
}

void _logPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}
