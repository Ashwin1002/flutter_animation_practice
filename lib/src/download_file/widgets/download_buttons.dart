import 'package:flutter/material.dart';

class DownloadButton extends StatelessWidget {
  const DownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Icon(
          Icons.file_download,
          size: 30.0,
        ),
      ),
    );
  }
}

class DownloadingButton extends StatelessWidget {
  const DownloadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeCap: StrokeCap.round,
      value: .9,
      strokeWidth: 6,
    );
  }
}

class DownloadedButton extends StatelessWidget {
  const DownloadedButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(
          Icons.file_download_done,
          size: 24.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
