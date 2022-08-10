extension ObjectNullableExtension on Object? {
  /// Convert current object to string
  String get toStringValue {
    final value = this;
    if (value is Enum) {
      return value.toStringValue;
    }
    return toString();
  }
}
