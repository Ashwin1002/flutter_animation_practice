import 'package:flutter/material.dart';
import 'package:flutter_animation_practice/src/download_file/utils/download_controller.dart';
import 'package:flutter_animation_practice/src/download_file/utils/download_status.dart';
import 'package:flutter_animation_practice/src/download_file/widgets/widgets.dart';

class DownloadFileScreen extends StatelessWidget {
  const DownloadFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Helper'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: DownloadTile(
            url:
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',
          ),
        ),
      ),
    );
  }
}

class DownloadTile extends StatefulWidget {
  const DownloadTile({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<DownloadTile> createState() => _DownloadTileState();
}

class _DownloadTileState extends State<DownloadTile> {
  // final DownloadStatus _status = DownloadStatus.notDownloaded;

  late DownloadController _downloadController;
  String? fileName;

  @override
  void initState() {
    super.initState();
    _downloadController = DownloadController(widget.url)..init();

    // fileName = _downloadController.fileName;
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
            ValueListenableBuilder(
              valueListenable: _downloadController.statusNotifier,
              builder: (context, status, _) {
                return status.when(
                  initial: () => DownloadButton(
                    onTap: () async =>
                        _downloadController.downloadFileWithProgress(),
                  ),
                  checking: () => const CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    strokeWidth: 6,
                    color: Colors.blue,
                  ),
                  downloading: () => _buildDownloadingButton(status),
                  done: () => DownloadedButton(
                    onTap: () {
                      print('downloaded');
                      _downloadController.deleteFile();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadingButton(DownloadStatus status) =>
      ValueListenableBuilder(
        valueListenable: _downloadController.downloadPercentNotifier,
        builder: (context, percent, child) {
          return DownloadingButton(
            isPaused: !status.isDownloading,
            onTap: () async => status.isDownloading
                ? _downloadController.pause()
                : _downloadController.downloadFileWithProgress(),
            value: percent,
          );
        },
      );
}
