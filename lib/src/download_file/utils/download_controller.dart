import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/src/download_file/utils/utils.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

typedef DownloadProgressCallback = void Function(int received, int total)?;

RegExp get _fileNameRegex => RegExp(r'[^/]+$');

///
/// A method which returns the base URL by removing the query parameters from the given URL.
///
String _getBaseUrl(String pUrl) {
  final parse = Uri.parse(pUrl);
  final uri = parse.query.isNotEmpty ? parse.replace(query: '') : parse;
  String url = uri.toString();
  if (url.endsWith('?')) url = url.replaceAll('?', '');
  return url;
}

///
/// DownloadController, a class which helps to ease the download process from the url
/// The key functions of the [DownloadController] are:
/// [downloadFile(), resumeDownload(), cancelDownload(), removeDownload()]
///
class DownloadController {
  ///
  /// [_url] the url to download the file
  ///
  final String _url;

  DownloadController(this._url);

  ///
  /// [init] must be called to initialize the download controller.
  /// The [_directory] is initialized, It is the reference to
  /// the folder where the file is stored in the system.
  ///
  void init({Directory? directory}) async {
    _directory = directory ?? await getTemporaryDirectory();
    await _checkDownloadPercentage();
  }

  ///
  /// Directory where the downloaded files will be stored
  ///
  late Directory _directory;

  ///
  /// Dio instance to handle HTTP requests
  ///
  final Dio _dio = Dio();

  ///
  /// CancelToken instance to manage download cancellations
  ///
  CancelToken _cancelToken = CancelToken();

  ///
  /// ValueNotifier to track download status
  ///
  ValueNotifier<DownloadStatus> statusNotifier =
      ValueNotifier<DownloadStatus>(DownloadStatus.initial);

  ///
  /// ValueNotifier to track download percentage
  ///
  ValueNotifier<double> downloadPercentNotifier = ValueNotifier<double>(0);

  ///
  /// Getter method to get the original download URL
  ///
  String get url => _url;

  ///
  /// List to store sizes of file chunks
  ///
  final List<int> _sizes = [];

  ///
  /// Getter to get file name with extension
  ///
  String? get fileNameWithExtension {
    final match = _fileNameRegex.firstMatch(_url);
    return match?.group(0);
  }

  ///
  /// Getter to get the file type (extension)
  ///
  String get fileType => _url.split('.').last;

  ///
  /// Getter to get the local file path for caching purposes
  ///
  String get localFilePath {
    String temporaryDirectoryPath = _directory.path;
    String urlData = removeDiacritics(Uri.decodeFull(url)).replaceAll(' ', '_');
    var baseUrl = _getBaseUrl(urlData);
    String fileBaseName = path.basename(baseUrl);
    return path.join(temporaryDirectoryPath, 'Files', fileBaseName);
  }

  ///
  /// Struct to get file data including file object, directory, file name, and extension
  ///
  ({File file, String directory, String basename, String extension})
      get fileData => (
            file: File(localFilePath),
            directory: path.dirname(localFilePath),
            extension: path.extension(localFilePath),
            basename: path.basenameWithoutExtension(localFilePath),
          );

  ///
  /// Checks the current download percentage
  ///
  Future<void> _checkDownloadPercentage() async {
    String localRoute = localFilePath;
    File localFileData = File(localRoute);

    if (_sizes.isNotEmpty) {
      _sizes.clear();
    }

    int sumSizes = 0;
    bool isFullFile = false;

    Response response = await _dio.head(_url);
    int originalFileSize =
        int.parse(response.headers.value('content-length') ?? '0');

    bool isFileExistSync = localFileData.existsSync();

    if (!isFileExistSync) {
      statusNotifier.value = DownloadStatus.notDownloaded;
    } else {
      int localSize = localFileData.lengthSync();
      _sizes.add(localSize);

      int i = 1;

      localRoute = '${fileData.directory}/${fileData.basename}'
          '($i)${fileData.extension}';

      File tempFile = File(localRoute);

      while (tempFile.existsSync()) {
        int tempSize = tempFile.lengthSync();
        _sizes.add(tempSize);
        i++;
        localRoute = '${fileData.directory}/${fileData.basename}}'
            '($i)${fileData.extension}';
        tempFile = File(localRoute);
      }

      sumSizes = _sizes.fold(0, (p, c) => p + c);

      isFullFile = sumSizes == originalFileSize;
    }

    var percent = sumSizes / originalFileSize;

    log('percentage complete => $percent');

    downloadPercentNotifier.value = percent;

    statusNotifier.value = isFullFile
        ? DownloadStatus.done
        : percent == 0
            ? DownloadStatus.notDownloaded
            : DownloadStatus.partiallyDownloaded;
  }

  ///
  /// Pauses the download and updates the download percentage
  ///
  void pause() async {
    _cancelToken.cancel();
    await _checkDownloadPercentage();
  }

  ///
  /// Deletes the local file and resets the download progress
  ///
  void deleteFile() {
    statusNotifier.value = DownloadStatus.initial;

    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        if (fileData.file.existsSync()) {
          fileData.file.delete();
        }
        downloadPercentNotifier.value = 0.0;
        statusNotifier.value = DownloadStatus.notDownloaded;
      },
    );
  }

  ///
  /// Handles the download progress and updates the status accordingly
  ///
  void _onReceiveProgress(int received, int total) {
    if (_cancelToken.isCancelled) return;

    statusNotifier.value = DownloadStatus.downloading;

    int receivedBytes = received + _sizes.fold(0, (p, c) => p + c);

    downloadPercentNotifier.value = receivedBytes / total;

    debugPrint(
        'recieved: ${received.toFileSize()}\ntotal: ${total.toFileSize()}\n'
        'percentNotifier: ${(downloadPercentNotifier.value * 100).toStringAsFixed(2)}');
  }

  ///
  /// Downloads the file with progress tracking
  ///
  Future<void> downloadFileWithProgress() async {
    statusNotifier.value = DownloadStatus.initial;
    String localRoute = localFilePath;
    File localFileData = File(localRoute);

    if (_sizes.isNotEmpty) {
      _sizes.clear();
    }

    Response response = await _dio.head(_url);
    int originalFileSize =
        int.parse(response.headers.value('content-length') ?? '0');

    Options? options;

    bool isFileExistSync = localFileData.existsSync();

    if (isFileExistSync) {
      statusNotifier.value = DownloadStatus.partiallyDownloaded;
      int localSize = localFileData.lengthSync();
      _sizes.add(localSize);

      int i = 1;

      localRoute = '${fileData.directory}/${fileData.basename}'
          '($i)${fileData.extension}';

      File tempFile = File(localRoute);

      while (tempFile.existsSync()) {
        int tempSize = tempFile.lengthSync();
        _sizes.add(tempSize);
        i++;
        localRoute = '${fileData.directory}/${fileData.basename}'
            '($i)${fileData.extension}';
        tempFile = File(localRoute);
      }

      int sumSizes = _sizes.fold(0, (p, c) => p + c);

      if (sumSizes < originalFileSize) {
        log('still need to download');
        options = Options(
          headers: {'Range': 'bytes=$sumSizes-'},
        );
      } else {
        log('has downloaded already');
        await _checkDownloadPercentage();
        return;
      }
    }

    if (downloadPercentNotifier.value > 0 ||
        downloadPercentNotifier.value < 1) {
      if (_cancelToken.isCancelled) {
        _cancelToken = CancelToken();
      }

      try {
        await _dio.download(
          _url,
          localRoute,
          options: options,
          cancelToken: _cancelToken,
          deleteOnError: false,
          onReceiveProgress: _onReceiveProgress,
        );
      } catch (e) {
        debugPrint('..dio.download()...ERROR: "${e.toString()}"');
        return;
      }
    }

    if (isFileExistSync) {
      var raf = await fileData.file.open(mode: FileMode.writeOnlyAppend);

      int i = 1;
      String filePartLocalRouteStr =
          '${fileData.directory}/${fileData.basename}'
          '($i)${fileData.extension}';
      File f = File(filePartLocalRouteStr);
      while (f.existsSync()) {
        raf = await raf.writeFrom(await f.readAsBytes());
        await f.delete();

        i++;
        filePartLocalRouteStr = '${fileData.directory}/${fileData.basename}'
            '($i)${fileData.extension}';
        f = File(filePartLocalRouteStr);
      }
      await raf.close();

      statusNotifier.value = DownloadStatus.done;
    }
  }
}
