class StringUtil {
  static bool isNullOrEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  static bool isNotNullOrEmpty(String? str) {
    return !isNullOrEmpty(str);
  }

  static String formatSize(int size) {
    if (size < 1024) {
      return '$size B';
    }
    const units = ['KB', 'MB', 'GB', 'TB'];
    int i = -1;
    double newSize = size.toDouble();
    while (newSize >= 1024 && i < units.length - 1) {
      newSize /= 1024;
      i++;
    }
    return '${newSize.toStringAsFixed(1)} ${units[i]}';
  }
}
