import 'package:json_annotation/json_annotation.dart';
import 'package:kassku_mobile/utils/enums.dart';

part 'transaction_chart.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionChart {
  TransactionChart(this.transactionType, this.date, this.amount);

  factory TransactionChart.fromJson(Map<String, dynamic> json) =>
      _$TransactionChartFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionChartToJson(this);

  @JsonKey(name: 'transaction_type')
  final TransactionType transactionType;

  final DateTime date;

  num amount;
}

class TransactionChartXY1Y2 {
  TransactionChartXY1Y2(this.x, this.y1, this.y2);
  DateTime x;
  num y1;
  num y2;
}
