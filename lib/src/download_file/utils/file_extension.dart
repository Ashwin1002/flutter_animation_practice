import 'dart:io';

import 'package:path/path.dart' as dir_path;

extension FileExtension on File {
  /// Gets the part of [path] before the last separator.
  ///
  ///     p.dirname('path/to/foo.dart'); // -> 'path/to'
  ///     p.dirname('path/to');          // -> 'path'
  ///
  /// Trailing separators are ignored.
  ///
  ///     p.dirname('path/to/'); // -> 'path'
  ///
  /// If an absolute path contains no directories, only a root, then the root
  /// is returned.
  ///
  ///     p.dirname('/');  // -> '/' (posix)
  ///     p.dirname('c:\');  // -> 'c:\' (windows)
  ///
  /// If a relative path has no directories, then '.' is returned.
  ///
  ///     p.dirname('foo');  // -> '.'
  ///     p.dirname('');  // -> '.'
  String get directory => dir_path.dirname(path);

  /// Gets the file extension of [path]: the portion of [basename] from the last
  /// `.` to the end (including the `.` itself).
  ///
  ///     p.extension('path/to/foo.dart');    // -> '.dart'
  ///     p.extension('path/to/foo');         // -> ''
  ///     p.extension('path.to/foo');         // -> ''
  ///     p.extension('path/to/foo.dart.js'); // -> '.js'
  ///
  /// If the file name starts with a `.`, then that is not considered the
  /// extension:
  ///
  ///     p.extension('~/.bashrc');    // -> ''
  ///     p.extension('~/.notes.txt'); // -> '.txt'
  ///
  /// Takes an optional parameter `level` which makes possible to return
  /// multiple extensions having `level` number of dots. If `level` exceeds the
  /// number of dots, the full extension is returned. The value of `level` must
  /// be greater than 0, else `RangeError` is thrown.
  ///
  ///     p.extension('foo.bar.dart.js', 2);   // -> '.dart.js
  ///     p.extension('foo.bar.dart.js', 3);   // -> '.bar.dart.js'
  ///     p.extension('foo.bar.dart.js', 10);  // -> '.bar.dart.js'
  ///     p.extension('path/to/foo.bar.dart.js', 2);  // -> '.dart.js'
  String extension([int level = 1]) => dir_path.extension(path, level);

  /// Gets the part of [path] after the last separator, and without any trailing
  /// file extension.
  ///
  ///     p.basenameWithoutExtension('path/to/foo.dart'); // -> 'foo'
  ///
  /// Trailing separators are ignored.
  ///
  ///     p.basenameWithoutExtension('path/to/foo.dart/'); // -> 'foo'
  String get basename => dir_path.basenameWithoutExtension(path);

  ///
  /// Gets the file name
  ///
  String get fileName => dir_path.basename(path);

  ///
  /// Gets the file name with [DateTime.now().millisecondsSinceEpoch]
  ///
  String get fileNameWithMilliseconds =>
      '${basename}_${DateTime.now().millisecondsSinceEpoch}${extension()}';
}
