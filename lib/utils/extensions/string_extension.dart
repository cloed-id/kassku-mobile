/// Helper to add extension to a string.
extension StringExtension on String {
  /// Convert current string to capitalize
  String get capitalize {
    if (isEmpty) {
      return '-';
    }
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Convert current string to capitalize for each word
  String get capitalizeFirstOfEach =>
      split(' ').map((str) => str.toLowerCase().capitalize).join(' ');

  String get toStringValue {
    return this;
  }
}

extension StringNullableExtension on String? {
  /// Not Null and Empty
  bool get isNotNullAndEmpty => this != null && this!.isNotEmpty;
}
