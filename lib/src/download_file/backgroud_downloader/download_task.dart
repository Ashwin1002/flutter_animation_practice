import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/src/download_file/backgroud_downloader/download_status.dart';
import 'package:flutter_animation_practice/src/download_file/backgroud_downloader/request.dart';

class DownloadListener {
  final Request request;

  DownloadListener(this.request);

  ValueNotifier<DownloadStatus> status =
      ValueNotifier<DownloadStatus>(DownloadStatus.queued);
  ValueNotifier<double> progress = ValueNotifier<double>(0);

  Future<DownloadStatus> whenDownloadComplete({
    Duration timeout = const Duration(hours: 2),
  }) async {
    var completer = Completer<DownloadStatus>();

    if (status.value.isCompleted) {
      completer.complete(status.value);
    }
    void Function()? listener;

    listener = () {
      if (status.value.isCompleted) {
        completer.complete(status.value);
        if (listener != null) {
          status.removeListener(listener);
        }
      }
    };

    status.addListener(listener);

    return completer.future.timeout(timeout);
  }
}
