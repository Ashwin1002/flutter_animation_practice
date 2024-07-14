import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

typedef DownloadProgressCallback = void Function(int recieved, int total)?;

RegExp get _fileNameRegex => RegExp(r'[^/]+$');

/// Returns the base URL by removing the query parameters from the given URL.
String _getBaseUrl(String pUrl) {
  // Parse the provided URL.
  final parse = Uri.parse(pUrl);

  // Remove the query parameters if present.
  final uri = parse.query.isNotEmpty ? parse.replace(query: '') : parse;

  // Convert the URI to string and ensure it doesn't end with '?'.
  String url = uri.toString();
  if (url.endsWith('?')) url = url.replaceAll('?', '');

  return url;
}

class DownloadController extends ChangeNotifier {
  final String _url;

  DownloadController({
    required String url,
  }) : _url = url;

  /// [init] must be called to intialize download controller
  void init({
    Directory? directory,
  }) async {
    _directory = directory ?? await getTemporaryDirectory();
  }

  /// Directory where the downloaded files will be stored
  late Directory _directory;

  /// Dio instance [_dio] to download files
  final Dio _dio = Dio();

  ///Get Original downloadurl
  String get url => _url;

  /// Get file name which is to be saved in files
  String? get fileName {
    final match = _fileNameRegex.firstMatch(_url);
    if (match != null) {
      return match.group(0);
    }
    return null;
  }

  String get fileType => _url.split('.').last;

  Future<void> download({
    CancelToken? cancelToken,
    DownloadProgressCallback onRecieveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _dio.download(
      _url,
      localFilePath,
      cancelToken: cancelToken,
      onReceiveProgress: onRecieveProgress,
      options: options,
      queryParameters: queryParameters,
    );
  }

  /// Constructs the local file path for caching purposes.
  ///
  /// The function removes diacritics from the URL, decodes it, replaces spaces with underscores,
  /// and then constructs a local file path using the temporary directory path and the file name
  /// derived from the base URL.
  String get localFilePath {
    // Get the path of the temporary directory.
    String? temporaryDirectoryPath = _directory.path;

    // Remove diacritics and decode the URL, then replace spaces with underscores.
    String urlData = removeDiacritics(Uri.decodeFull(url)).replaceAll(' ', '_');

    // Get the base URL without query parameters.
    var baseUrl = _getBaseUrl(urlData);

    // Extract the file name from the base URL.
    String fileBaseName = path.basename(baseUrl);

    // Construct and return the local cache file path.
    return path.join(temporaryDirectoryPath, 'Files', fileBaseName);
  }

  Future<File?> getFileProgress() async {
    /// File object of [localFile]
    File localFile = File(localFilePath);

    /// Gets the part of [directory] before the last separator
    String directory = path.dirname(localFilePath);

    /// Gets the part of [fileName] after the last separator, and without any trailing file extension.
    String fileName = path.basenameWithoutExtension(localFilePath);

    /// Gets the file extension of [extensiion]: the portion of [fileName] from the last . to the end (including the . itself).
    String extension = path.extension(localFilePath);

    String localRoute = localFilePath;

    return null;
  }
}
