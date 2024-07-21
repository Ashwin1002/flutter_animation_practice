enum DownloadStatus {
  queued(false),
  downloading(false),
  completed(true),
  failed(true),
  paused(false),
  cancelled(true);

  const DownloadStatus(this.isComplete);

  final bool isComplete;

  bool get isQueued => this == DownloadStatus.queued;
  bool get isDownloading => this == DownloadStatus.downloading;
  bool get isCompleted => this == DownloadStatus.completed;
  bool get isFailed => this == DownloadStatus.failed;
  bool get isPaused => this == DownloadStatus.paused;
  bool get isCancelled => this == DownloadStatus.cancelled;
}

extension DownloadStatusExt on DownloadStatus {
  A when<A>({
    required A Function() initial,
    required A Function() downloading,
    required A Function() done,
    required A Function() checking,
  }) {
    return switch (this) {
      DownloadStatus.completed ||
      DownloadStatus.failed ||
      DownloadStatus.cancelled =>
        done(),
      DownloadStatus.downloading => downloading(),
      DownloadStatus.queued => initial(),
      _ => checking(),
    };
  }
}
