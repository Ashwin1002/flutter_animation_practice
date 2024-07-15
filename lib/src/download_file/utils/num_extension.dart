extension NumExtension on num {
  /// Returns a human-readable string representing a file size.
  String toFileSize([int round = 2]) {
    // Divider used for size conversion (1 KB = 1024 B, 1 MB = 1024 KB, etc.)
    const int divider = 1024;

    // List of size units in ascending order
    const List<String> units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];

    // Variable to hold the parsed size value
    int size0;

    // Try to parse the size parameter to an integer
    try {
      size0 = int.parse(toString());
    } catch (e) {
      // Throw an error if parsing fails
      throw ArgumentError('Cannot parse the size parameter: $e');
    }

    // Loop through the list of units to find the appropriate unit
    for (int i = 0; i < units.length; i++) {
      // Calculate the current divider for the unit
      int currentDivider = divider * (i == 0 ? 1 : (1 << (10 * i)));

      // Check if the size is smaller than the current divider
      if (size0 < currentDivider) {
        // Return the size formatted to the appropriate unit
        return '${(size0 / (currentDivider / divider)).toStringAsFixed(i == 0 ? 0 : round)} ${units[i]}';
      }
    }

    // If the size is larger than 1 PB, return it formatted as PB
    return '${(size0 / (divider * divider * divider * divider * divider)).toStringAsFixed(round)} PB';
  }
}
