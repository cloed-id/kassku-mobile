part of 'transactions_bloc.dart';

abstract class TransactionsState extends Equatable {
  const TransactionsState(this.transactions);

  final List<Transaction> transactions;

  @override
  List<Object?> get props => [transactions];
}

class TransactionsInitial extends TransactionsState {
  TransactionsInitial() : super([]);
}

class TransactionsLoading extends TransactionsState {
  TransactionsLoading(TransactionsState state) : super(state.transactions);
}

class TransactionsLoaded extends TransactionsState {
  const TransactionsLoaded(super.transactions);
}

class TransactionsCreated extends TransactionsState {
  const TransactionsCreated(super.transactions);
}

class TransactionsError extends TransactionsState {
  TransactionsError(TransactionsState state, this.message)
      : super(state.transactions);

  final String message;
}
