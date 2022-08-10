import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/category.dart';
import 'package:kassku_mobile/models/transaction.dart';
import 'package:kassku_mobile/models/workspace.dart';
import 'package:kassku_mobile/modules/transactions/bloc/categories_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/transactions_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/extensions/string_extension.dart';
import 'package:kassku_mobile/utils/extensions/widget_extension.dart';
import 'package:kassku_mobile/utils/functions.dart';

part 'package:kassku_mobile/modules/transactions/view/widgets/form_workspace_dialog.dart';
part 'package:kassku_mobile/modules/transactions/view/widgets/form_transaction_dialog.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: ColorName.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Kassku Mobile',
                        style: TextStyle(
                          color: ColorName.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        color: ColorName.white,
                        onPressed: () {
                          final workspaceBloc = context.read<WorkspacesBloc>();
                          BlocProvider.value(
                            value: workspaceBloc,
                            child: const _FormWorkspaceDialog(),
                          ).showCustomDialog<void>(context);
                        },
                        icon: const Icon(Icons.add),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<WorkspacesBloc, WorkspacesState>(
                    builder: (context, state) {
                      if (state is WorkspacesLoaded) {
                        if (state.workspaces.isEmpty) return const SizedBox();

                        return DropdownButton<Workspace>(
                          value: state.selected,
                          style: const TextStyle(
                            color: ColorName.white,
                            fontWeight: FontWeight.bold,
                          ),
                          isExpanded: true,
                          dropdownColor: ColorName.primaryVariant,
                          underline: const SizedBox(),
                          items: state.workspaces
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name.capitalize),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }

                            context
                                .read<WorkspacesBloc>()
                                .add(SelectWorkspace(workspace: value));
                          },
                        );
                      } else if (state is WorkspacesError) {
                        return Text(
                          state.message,
                          style: const TextStyle(
                            color: ColorName.errorForeground,
                          ),
                        );
                      }

                      return const LinearProgressIndicator();
                    },
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text('Transactions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                GetIt.I<UserHelper>().logout();
              },
            ),
          ],
        ),
      ),
      body: BlocConsumer<WorkspacesBloc, WorkspacesState>(
        listener: (context, state) {
          if (state is WorkspacesSuccess) {
            context.read<WorkspacesBloc>().add(const FetchWorkspaces(key: ''));
          }
        },
        builder: (context, state) {
          if (state is WorkspacesLoaded) {
            if (state.workspaces.isEmpty) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No Workspace, ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        final workspaceBloc = context.read<WorkspacesBloc>();
                        BlocProvider.value(
                          value: workspaceBloc,
                          child: const _FormWorkspaceDialog(),
                        ).showCustomDialog<void>(context);
                      },
                      child: const Text('please create one'),
                    )
                  ],
                ),
              );
            }

            return Center(
              child: BlocProvider(
                create: (context) => TransactionsBloc()
                  ..add(
                    FetchTransactions(
                      state.selected!.id,
                      state.selected!.memberWorkspaceId,
                      key: '',
                    ),
                  ),
                child: BlocListener<WorkspacesBloc, WorkspacesState>(
                  listener: (context, state) {
                    if (state is WorkspacesSelected) {
                      context.read<TransactionsBloc>().add(
                            FetchTransactions(
                              state.selected!.id,
                              state.selected!.memberWorkspaceId,
                              key: '',
                            ),
                          );
                    }
                  },
                  child: const _TransactionsList(),
                ),
              ),
            );
          } else if (state is WorkspacesError) {
            return Text(
              state.message,
              style: const TextStyle(
                color: ColorName.errorForeground,
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class _TransactionsList extends StatelessWidget {
  const _TransactionsList({super.key});

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
      child: const _FormTransactionDialog(),
    ).showCustomDialog<void>(context);
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = context.watch<TransactionsBloc>().state;

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
              const Text(
                'No Transactions, ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _openTrxDialog(context),
                child: const Text('please create one'),
              )
            ],
          ),
        );
      }

      return Stack(
        children: [
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: transactions.length,
            itemBuilder: (context, index) => _TransactionItem(
              transaction: transactions[index],
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () => _openTrxDialog(context),
              child: const Icon(Icons.add),
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
  const _TransactionItem({required this.transaction});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transaction.type == TransactionType.income
            ? Icons.arrow_circle_up
            : Icons.arrow_circle_down,
      ),
      title: Text(transaction.categoryName.capitalize),
      subtitle: Text(transaction.description.capitalize),
      trailing: Text(currencyFormatterNoLeading.format(transaction.amount)),
    );
  }
}
