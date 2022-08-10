// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      json['id'] as String,
      json['amount'] as int,
      $enumDecode(_$TransactionTypeEnumMap, json['transaction_type']),
      DateTime.parse(json['created_at'] as String),
      DateTime.parse(json['updated_at'] as String),
      json['description'] as String,
      json['category_name'] as String,
      json['workspace_name'] as String,
      json['created_by'] == null
          ? null
          : User.fromJson(json['created_by'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'transaction_type': _$TransactionTypeEnumMap[instance.type]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'description': instance.description,
      'category_name': instance.categoryName,
      'workspace_name': instance.workspaceName,
      'created_by': instance.createdBy?.toJson(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'INCOME',
  TransactionType.expense: 'EXPENSE',
};
