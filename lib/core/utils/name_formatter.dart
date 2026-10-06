class NameFormatter {
  /// Formats the director's name with an appropriate professional title prefix.
  /// If isArabic is true: prefixes with 'م. '
  /// If isArabic is false: prefixes with 'Eng. '
  /// Automatically strips any redundant or duplicate existing titles.
  static String formatWithTitle(String? name, {required bool isArabic}) {
    if (name == null || name.trim().isEmpty) {
      return isArabic ? 'م. مشارك' : 'Eng. Participant';
    }
    final clean = name.replaceFirst(RegExp(r'^(Eng\.|Eng|م\.|م|Engineer)\s+', caseSensitive: false), '').trim();
    final prefix = isArabic ? 'م. ' : 'Eng. ';
    return '$prefix$clean';
  }

  /// Extracts the clean initial letter of the director's name (skipping titles like Eng./م.)
  static String getInitial(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    final clean = name.replaceFirst(RegExp(r'^(Eng\.|Eng|م\.|م|Engineer)\s+', caseSensitive: false), '').trim();
    return clean.isNotEmpty ? clean[0].toUpperCase() : 'U';
  }
}
