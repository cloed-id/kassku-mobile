part of 'package:kassku_mobile/modules/transactions/view/main_screen.dart';

class _TransactionTypeCubit extends Cubit<TransactionType?> {
  _TransactionTypeCubit() : super(null);

  void changeTransactionType(TransactionType type) {
    emit(type);
  }
}

class _IsAddingCategoryCubit extends Cubit<bool> {
  _IsAddingCategoryCubit() : super(false);

  void changeIsAddingCategory({required bool isAdding}) {
    emit(isAdding);
  }
}

class _CategoryFieldValueCubit extends Cubit<String> {
  _CategoryFieldValueCubit() : super('');

  void changeCategoryValue({required String value}) {
    emit(value);
  }
}

class FormTransactionDialog extends StatelessWidget {
  const FormTransactionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionBloc = BlocProvider.of<TransactionsBloc>(context);
    final workspaceBloc = BlocProvider.of<WorkspacesBloc>(context);

    final workspaceId = workspaceBloc.state.selected?.id;

    if (workspaceId == null) {
      return const Center(
        child: Text('Pilih area kerja terlebih dahulu'),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _CategoryFieldValueCubit(),
        ),
        BlocProvider(
          create: (context) => _IsAddingCategoryCubit(),
        ),
        BlocProvider(
          create: (context) => _TransactionTypeCubit(),
        ),
        BlocProvider(
          create: (context) => _TransactionTypeCubit(),
        ),
        BlocProvider(
          create: (context) =>
              CategoriesBloc(workspaceId)..add(const FetchCategories(key: '')),
        ),
        BlocProvider.value(value: transactionBloc),
        BlocProvider.value(value: workspaceBloc)
      ],
      child: const _FormTransactionBodyDialog(),
    );
  }
}

class _FormTransactionBodyDialog extends StatefulWidget {
  const _FormTransactionBodyDialog({super.key});

  @override
  State<_FormTransactionBodyDialog> createState() =>
      _FormTransactionBodyDialogState();
}

class _FormTransactionBodyDialogState
    extends State<_FormTransactionBodyDialog> {
  final _scrollC = ScrollController();
  String _amount = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    final workspace = context.watch<WorkspacesBloc>().state.selected!;

    return BlocListener<TransactionsBloc, TransactionsState>(
      listener: (context, state) {
        if (state is TransactionsCreated) {
          final workspace =
              BlocProvider.of<WorkspacesBloc>(context).state.selected;

          if (workspace == null) {
            GetIt.I<FlashMessageHelper>().showError('Terjadi kesalahan');
            return;
          }
          context
              .read<WorkspacesBloc>()
              .add(FetchWorkspace(memberId: workspace.memberWorkspaceId));
          Navigator.of(context).pop();
        }
      },
      child: Scrollbar(
        controller: _scrollC,
        thumbVisibility: true,
        child: ListView(
          shrinkWrap: true,
          controller: _scrollC,
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Buat Transaksi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<_TransactionTypeCubit, TransactionType?>(
              builder: (context, state) {
                return Row(
                  children: [
                    if (workspace.role == 'admin' ||
                        workspace.permissions.contains('create_income'))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(
                            'Pemasukan',
                            style: TextStyle(
                              color: state == TransactionType.income
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          selected: state == TransactionType.income,
                          selectedColor: ColorName.primary,
                          onSelected: (selected) {
                            if (selected) {
                              context
                                  .read<_TransactionTypeCubit>()
                                  .changeTransactionType(
                                      TransactionType.income);
                            }
                          },
                        ),
                      ),
                    if (workspace.role == 'admin' ||
                        workspace.permissions.contains('create_expense'))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(
                            'Pengeluaran',
                            style: TextStyle(
                              color: state == TransactionType.expense
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          selected: state == TransactionType.expense,
                          selectedColor: ColorName.primary,
                          onSelected: (selected) {
                            if (selected) {
                              context
                                  .read<_TransactionTypeCubit>()
                                  .changeTransactionType(
                                      TransactionType.expense);
                            }
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 4),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                hintText: 'Masukan nominal transaksi...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
              onChanged: (value) {
                _amount = value;
              },
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Masukan deskripsi transaksi...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
              onChanged: (value) {
                _description = value;
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<CategoriesBloc, CategoriesState>(
              builder: (context, state) {
                if (state is CategoriesError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                if (state is CategoriesLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pilih kategori',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...state.categories
                              .map(
                                (category) => _CategoryChip(category: category),
                              )
                              .toList(),
                          const _AddingCategoryWidget(),
                        ],
                      ),
                    ],
                  );
                }
                return const SizedBox(
                  height: 32,
                  child: Center(
                    child: LinearProgressIndicator(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: BlocBuilder<_IsAddingCategoryCubit, bool>(
                builder: (_, categoryState) {
                  return BlocBuilder<TransactionsBloc, TransactionsState>(
                    builder: (context, transactionState) {
                      if (transactionState is TransactionsLoading) {
                        return const SizedBox(
                          width: 70,
                          height: 35,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return ElevatedButton(
                        onPressed: categoryState
                            ? null
                            : () {
                                final type =
                                    context.read<_TransactionTypeCubit>().state;
                                final category = context
                                    .read<CategoriesBloc>()
                                    .state
                                    .categories
                                    .firstWhere(
                                        (element) => element.isSelected);

                                final amount = int.tryParse(_amount);

                                if (amount == null) {
                                  GetIt.I<FlashMessageHelper>()
                                      .showError('Nominal tidak valid');
                                  return;
                                }

                                if (type == null) {
                                  GetIt.I<FlashMessageHelper>().showError(
                                    'Silahkan pilih tipe transaksi',
                                  );
                                  return;
                                }

                                final workspace =
                                    context.read<WorkspacesBloc>().state;

                                context.read<TransactionsBloc>().add(
                                      CreateTransactions(
                                        workspace.selected!.id,
                                        workspace.selected!.memberWorkspaceId,
                                        category.id,
                                        _description,
                                        amount,
                                        type,
                                      ),
                                    );
                              },
                        child: const Text('Simpan'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddingCategoryWidget extends StatelessWidget {
  const _AddingCategoryWidget({super.key});

  void _onSubmit(BuildContext context) {
    context
        .read<_IsAddingCategoryCubit>()
        .changeIsAddingCategory(isAdding: false);

    final value = context.read<_CategoryFieldValueCubit>().state;

    context.read<CategoriesBloc>().add(CreateCategory(name: value));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<_IsAddingCategoryCubit>().state;

    if (state) {
      return TextFormField(
        initialValue: '',
        autofocus: true,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return 'Kategori tidak boleh kosong';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Masukan nama kategori baru...',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.black54),
          ),
          suffixIcon: GestureDetector(
            onTap: () => _onSubmit(context),
            child: const Icon(Icons.check),
          ),
        ),
        onChanged: (value) {
          context
              .read<_CategoryFieldValueCubit>()
              .changeCategoryValue(value: value);
        },
        onFieldSubmitted: (value) => _onSubmit(context),
        textInputAction: TextInputAction.done,
      );
    }

    return ActionChip(
      onPressed: () {
        context
            .read<_IsAddingCategoryCubit>()
            .changeIsAddingCategory(isAdding: true);
      },
      backgroundColor: ColorName.primary.withOpacity(0.5),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.add,
            color: ColorName.white,
          ),
          Text(
            'Tambah kategori',
            style: TextStyle(color: ColorName.white),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        category.textContent.originalText.capitalizeFirstOfEach,
        style: TextStyle(
          color: category.isSelected ? Colors.white : Colors.black,
        ),
      ),
      selected: category.isSelected,
      selectedColor: ColorName.primary,
      onSelected: (selected) {
        category.isSelected = selected;
        context.read<CategoriesBloc>().add(SelectCategory(category));
      },
    );
  }
}
