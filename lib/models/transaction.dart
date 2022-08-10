import 'package:json_annotation/json_annotation.dart';
import 'package:kassku_mobile/models/user.dart';
import 'package:kassku_mobile/utils/enums.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true)
class Transaction {
  Transaction(
    this.id,
    this.amount,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.categoryName,
    this.workspaceName,
    this.createdBy,
  );

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  final String id;

  final int amount;

  @JsonKey(name: 'transaction_type')
  final TransactionType type;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  final String description;

  @JsonKey(name: 'category_name')
  final String categoryName;

  @JsonKey(name: 'workspace_name')
  final String workspaceName;

  @JsonKey(name: 'created_by')
  final User? createdBy;
}
