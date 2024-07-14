import 'package:flutter/material.dart';

RegExp get _fileNameRegex => RegExp(r'[^/]+$');

class DownloadController extends ChangeNotifier {
  final String _url;

  DownloadController({
    required String url,
  }) : _url = url;

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
}
