part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent(this.workspaceId, this.memberWorkspaceId);
  final String workspaceId;
  final String memberWorkspaceId;
}

class FetchTransactions extends TransactionsEvent {
  const FetchTransactions(
    super.workspaceId,
    super.memberWorkspaceId, {
    required this.key,
  });

  final String key;

  @override
  List<Object> get props => [key];
}

class CreateTransactions extends TransactionsEvent {
  const CreateTransactions(
    super.workspaceId,
    super.memberWorkspaceId,
    this.categoryId,
    this.description,
    this.amount,
    this.type,
  );

  final String categoryId;
  final String description;
  final int amount;
  final TransactionType type;

  @override
  List<Object> get props => [categoryId, description, amount, type];
}
