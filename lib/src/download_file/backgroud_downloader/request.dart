import 'package:dio/dio.dart';

class Request {
  final String url;
  final String path;

  CancelToken cancelToken = CancelToken();

  Request(
    this.url,
    this.path,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Request &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          path == other.path;

  @override
  int get hashCode => url.hashCode ^ path.hashCode;
}
