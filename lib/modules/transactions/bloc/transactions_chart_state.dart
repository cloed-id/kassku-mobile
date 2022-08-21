part of 'transactions_chart_bloc.dart';

abstract class TransactionsChartState extends Equatable {
  const TransactionsChartState(this.transactionsChart);

  final List<TransactionChartXY1Y2> transactionsChart;

  @override
  List<Object?> get props => [transactionsChart];
}

class TransactionsChartInitial extends TransactionsChartState {
  TransactionsChartInitial() : super([]);
}

class TransactionsChartLoading extends TransactionsChartState {
  TransactionsChartLoading(TransactionsChartState state)
      : super(state.transactionsChart);
}

class TransactionsChartLoaded extends TransactionsChartState {
  const TransactionsChartLoaded(super.transactionsChart);
}

class TransactionsChartCreated extends TransactionsChartState {
  const TransactionsChartCreated(super.transactionsChart);
}

class TransactionsChartError extends TransactionsChartState {
  TransactionsChartError(TransactionsChartState state, this.message)
      : super(state.transactionsChart);

  final String message;
}
