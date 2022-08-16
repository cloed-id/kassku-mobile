import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kassku_mobile/models/transaction.dart';
import 'package:kassku_mobile/repositories/transactions_repository.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/wrappers/error_wrapper.dart';

part 'transactions_event.dart';

part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc() : super(TransactionsInitial()) {
    on<FetchTransactions>(_searchTransactions);
    on<CreateTransactions>(_createTransaction);
  }

  final _repo = TransactionsRepository();

  Future<void> _searchTransactions(
    FetchTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(TransactionsLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.getTransactions(
        event.key,
        event.workspaceId,
        event.memberWorkspaceId,
      ),
      onError: (_) {
        emit(TransactionsLoaded(state.transactions));
        // emit(TransactionsError(state, 'Error loading transactions'));
      },
    );

    final data = result.data as List<Transaction>;

    emit(TransactionsLoaded(data));
  }

  Future<void> _createTransaction(
    CreateTransactions event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(TransactionsLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.createTransaction(
        event.workspaceId,
        event.memberWorkspaceId!,
        event.categoryId,
        event.description,
        event.amount,
        event.type,
      ),
      onError: (_) {
        emit(TransactionsLoaded(state.transactions));
      },
    );

    final list = state.transactions;

    emit(TransactionsCreated(list));

    emit(TransactionsLoaded([result.data as Transaction, ...list]));
  }
}
