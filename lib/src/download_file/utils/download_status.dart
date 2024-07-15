enum DownloadStatus {
  initial,
  partiallyDownloaded,
  notDownloaded,
  downloading,
  done;

  const DownloadStatus();

  bool get isInitial => this == DownloadStatus.initial;
  bool get isPartiallyDownloaded => this == DownloadStatus.partiallyDownloaded;
  bool get isDownloading => this == DownloadStatus.downloading;
  bool get isNotDownloaded => this == DownloadStatus.notDownloaded;
  bool get isDownloaded => this == DownloadStatus.done;
}

extension DownloadStatusExt on DownloadStatus {
  A when<A>({
    required A Function() initial,
    required A Function() downloading,
    required A Function() done,
    required A Function() checking,
  }) {
    return switch (this) {
      DownloadStatus.done => done(),
      DownloadStatus.downloading ||
      DownloadStatus.partiallyDownloaded =>
        downloading(),
      DownloadStatus.notDownloaded => initial(),
      _ => checking(),
    };
  }
}
