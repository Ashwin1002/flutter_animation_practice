import 'package:flutter/material.dart';

class DownloadController extends ChangeNotifier {
  RegExp get _fileNameRegex => RegExp(r'[^/]+$');

  String? getFileName(String url) {
    final match = _fileNameRegex.firstMatch(url);
    if (match != null) {
      return match.group(0);
    }
    return null;
  }
}
