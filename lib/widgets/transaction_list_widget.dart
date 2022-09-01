import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/models/transaction.dart';
import 'package:kassku_mobile/modules/transactions/bloc/transactions_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';
import 'package:kassku_mobile/modules/transactions/view/main_screen.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/extensions/string_extension.dart';
import 'package:kassku_mobile/utils/extensions/widget_extension.dart';
import 'package:kassku_mobile/utils/functions.dart';

class TransactionsListWidget extends StatelessWidget {
  const TransactionsListWidget({
    super.key,
    this.isWorkspaceTransactions = false,
    this.selectedMemberId,
  });

  final bool isWorkspaceTransactions;
  final String? selectedMemberId;

  void _openTrxDialog(BuildContext context) {
    final workspaceBloc = BlocProvider.of<WorkspacesBloc>(context);
    final transactionBloc = BlocProvider.of<TransactionsBloc>(context);

    MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: workspaceBloc,
        ),
        BlocProvider.value(
          value: transactionBloc,
        ),
      ],
      child: const FormTransactionDialog(),
    ).showCustomDialog<void>(context);
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = context.watch<TransactionsBloc>().state;

    final workspace = context.watch<WorkspacesBloc>().state.selected;

    if (workspace == null) {
      return const Text(
        'Tidak ada area kerja,',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final workspaceId = workspace.id;
    final memberWorkspaceId = selectedMemberId ?? workspace.memberWorkspaceId;

    if (transactionState is TransactionsError) {
      return Center(
        child: Text(transactionState.message),
      );
    }

    if (transactionState is TransactionsLoaded) {
      final transactions = transactionState.transactions;

      if (transactions.isEmpty) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  'Tidak ada transaksi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!isWorkspaceTransactions && selectedMemberId == null)
                ElevatedButton(
                  onPressed: () => _openTrxDialog(context),
                  child: const Text('silahkan buat'),
                )
            ],
          ),
        );
      }

      final list = Scrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: transactions.length + 1,
          itemBuilder: (context, index) {
            if (index == transactions.length) {
              return const SizedBox(height: 55);
            }

            return _TransactionItem(
              transaction: transactions[index],
              isWorkspaceTransaction: isWorkspaceTransactions,
            );
          },
        ),
      );

      return Stack(
        children: [
          if (!isWorkspaceTransactions)
            RefreshIndicator(
              onRefresh: () async {
                context.read<TransactionsBloc>().add(
                      FetchTransactions(
                        workspaceId,
                        memberWorkspaceId,
                        key: '',
                      ),
                    );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedMemberId != null)
                    const Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Text(
                        'Mutasi saldo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Expanded(child: list),
                ],
              ),
            )
          else
            list,
          if (!isWorkspaceTransactions)
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                backgroundColor: ColorName.secondaryContainer,
                onPressed: () => _openTrxDialog(context),
                child: const Icon(
                  Icons.add,
                  color: ColorName.white,
                ),
              ),
            ),
        ],
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({
    required this.transaction,
    required this.isWorkspaceTransaction,
  });

  final Transaction transaction;
  final bool isWorkspaceTransaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transaction.type == TransactionType.income
            ? Icons.arrow_drop_up_rounded
            : Icons.arrow_drop_down_rounded,
        size: 52,
        color: transaction.type == TransactionType.income
            ? ColorName.success
            : ColorName.errorForeground,
      ),
      title: Text(transaction.categoryName.capitalize),
      subtitle: Text(transaction.description.capitalize),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(currencyFormatterNoLeading.format(transaction.amount)),
          if (isWorkspaceTransaction)
            Text(transaction.createdBy?.username.capitalize ?? ''),
        ],
      ),
    );
  }
}
