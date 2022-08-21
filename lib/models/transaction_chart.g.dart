// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionChart _$TransactionChartFromJson(Map<String, dynamic> json) =>
    TransactionChart(
      $enumDecode(_$TransactionTypeEnumMap, json['transaction_type']),
      DateTime.parse(json['date'] as String),
      json['amount'] as num,
    );

Map<String, dynamic> _$TransactionChartToJson(TransactionChart instance) =>
    <String, dynamic>{
      'transaction_type': _$TransactionTypeEnumMap[instance.transactionType]!,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'INCOME',
  TransactionType.expense: 'EXPENSE',
};
