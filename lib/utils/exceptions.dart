import 'package:kassku_mobile/utils/typedefs.dart';

class CustomExceptionMap implements Exception {
  CustomExceptionMap(this.cause);
  MapString cause;
}

class CustomExceptionString implements Exception {
  CustomExceptionString(this.cause);
  String cause;

  @override
  String toString() {
    return cause;
  }
}
