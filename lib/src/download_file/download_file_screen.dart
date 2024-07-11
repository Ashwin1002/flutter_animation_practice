import 'package:flutter/material.dart';
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
                'https://resource.api.dev.medhavhi.com/media/resources/1ff4c29b-6902-4163-88d3-53c8c3022414.pdf',
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
  final DownloadStatus _status = DownloadStatus.notDownloaded;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            FilePreview(),
            SizedBox(width: 20.0),
            FileContent(),
            SizedBox(width: 20.0),
          ],
        ),
      ),
    );
  }
}
