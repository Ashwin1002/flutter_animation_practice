enum DownloadStatus {
  notDownloaded,
  downloading,
  done;

  const DownloadStatus();

  bool get isDownloading => this == DownloadStatus.downloading;
  bool get isNotDownloaded => this == DownloadStatus.notDownloaded;
  bool get isDownloaded => this == DownloadStatus.done;
}

extension DownloadStatusExt on DownloadStatus {
  A when<A>({
    required A Function() initial,
    required A Function() downloading,
    required A Function() done,
  }) {
    return switch (this) {
      DownloadStatus.done => done(),
      DownloadStatus.downloading => downloading(),
      _ => initial(),
    };
  }
}
