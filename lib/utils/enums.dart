import 'package:json_annotation/json_annotation.dart';

/// Handle status response from server
enum ResponseStatus {
  /// Example: "OK" ( 200 ), "CREATED" ( 201 ), "ACCEPTED" ( 202 )
  success,

  /// Example: "Error" ( 400 ), "Unauthorized" ( 401 ), "Unprocessable" ( 422)
  failed,
}

enum Language {
  defaultSystem,
  indonesia,
  english,
}

enum TransactionType {
  @JsonValue('INCOME')
  income,
  @JsonValue('EXPENSE')
  expense,
}
