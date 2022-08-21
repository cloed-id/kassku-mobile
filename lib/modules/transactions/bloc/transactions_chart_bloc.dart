import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kassku_mobile/models/transaction_chart.dart';
import 'package:kassku_mobile/repositories/transactions_repository.dart';
import 'package:kassku_mobile/utils/wrappers/error_wrapper.dart';

part 'transactions_chart_event.dart';
part 'transactions_chart_state.dart';

class TransactionsChartBloc
    extends Bloc<TransactionsChartEvent, TransactionsChartState> {
  TransactionsChartBloc() : super(TransactionsChartInitial()) {
    on<FetchTransactionsChartEvent>(_fetchTransactionsChartEvent);
  }

  final _repo = TransactionsRepository();

  Future<void> _fetchTransactionsChartEvent(
    FetchTransactionsChartEvent event,
    Emitter<TransactionsChartState> emit,
  ) async {
    emit(TransactionsChartLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.getTransactionsChart(
        event.workspaceId,
        event.startDate,
        event.endDate,
      ),
      onError: (_) {
        emit(TransactionsChartLoaded(state.transactionsChart));
      },
    );

    final data = result.data as List<TransactionChartXY1Y2>;

    emit(TransactionsChartLoaded(data));
  }
}
