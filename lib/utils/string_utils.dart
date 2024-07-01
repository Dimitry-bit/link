class StringUtils {
  static String toTitleCase(String s) {
    if (s.isEmpty) {
      return s;
    }

    return s[0].toUpperCase() + s.substring(1);
  }
}
