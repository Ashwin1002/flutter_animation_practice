import 'package:flutter/material.dart';

class FilePreview extends StatelessWidget {
  const FilePreview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      child: Image.asset(
        'assets/images/music.jpeg',
        height: 60,
        cacheHeight: (100 * MediaQuery.of(context).devicePixelRatio).toInt(),
      ),
    );
  }
}
