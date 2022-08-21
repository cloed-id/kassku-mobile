part of 'transactions_chart_bloc.dart';

abstract class TransactionsChartEvent extends Equatable {
  const TransactionsChartEvent(this.workspaceId, this.startDate, this.endDate);

  final String workspaceId;
  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object> get props => [workspaceId, startDate, endDate];
}

class FetchTransactionsChartEvent extends TransactionsChartEvent {
  const FetchTransactionsChartEvent(
    super.workspaceId,
    super.startDate,
    super.endDate,
  );
}
