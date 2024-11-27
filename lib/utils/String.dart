class StringUtil {
  static bool isNullOrEmpty(String? str) {
    return str == null || str.trim().isEmpty;
  }

  static bool isNotNullOrEmpty(String? str) {
    return !isNullOrEmpty(str);
  }
}
