// ignore_for_file: lines_longer_than_80_chars

part of 'package:kassku_mobile/modules/transactions/view/main_screen.dart';

class _ListMemberDialog extends StatelessWidget {
  const _ListMemberDialog({
    super.key,
    required this.label,
    required this.members,
    required this.workspace,
    this.ableToSetBalance = false,
  });

  final String label;
  final bool ableToSetBalance;
  final List<MemberWorkspace> members;
  final Workspace workspace;

  void _openAddMemberDialog(BuildContext context) {
    final workspaceMemberByParentBloc =
        BlocProvider.of<WorkspaceMemberByParentBloc>(context);
    final workspacesBloc = BlocProvider.of<WorkspacesBloc>(context);
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: workspaceMemberByParentBloc),
        BlocProvider.value(value: workspacesBloc)
      ],
      child: const FormAddMemberDialog(),
    ).showCustomDialog<void>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tidak ada anggota,',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _openAddMemberDialog(context),
              child: const Text('silahkan tambah'),
            )
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (ableToSetBalance)
                IconButton(
                  onPressed: () => _openAddMemberDialog(context),
                  icon: const Icon(Icons.person_add),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              final isYou = member.id == workspace.memberWorkspaceId;
              var title = member.username.capitalize;

              if (isYou) {
                title += ' - ( Anda )';
              }

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: ColorName.primary,
                  child: Text(
                    member.username.substring(0, 1).capitalize,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorName.white,
                    ),
                  ),
                ),
                title: Text(title),
                subtitle: Text(member.role.name.capitalize),
                trailing: member.balance != null
                    ? Text(currencyFormatterNoLeading.format(member.balance))
                    : null,
                onTap: ableToSetBalance
                    ? () {
                        final workspaceMemberByParentBloc =
                            BlocProvider.of<WorkspaceMemberByParentBloc>(
                          context,
                        );

                        final workspacesBloc = BlocProvider.of<WorkspacesBloc>(
                          context,
                        );
                        showDialog<void>(
                          context: context,
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: workspaceMemberByParentBloc,
                              ),
                              BlocProvider.value(
                                value: workspacesBloc,
                              ),
                            ],
                            child: _SetMemberBalanceDialog(
                              workspace: workspace,
                              memberId: member.id,
                            ),
                          ),
                        );
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AmountCubit extends Cubit<int> {
  _AmountCubit() : super(0);

  void setAmount(int amount) {
    emit(amount);
  }
}

class _SetMemberBalanceDialog extends StatelessWidget {
  const _SetMemberBalanceDialog({
    super.key,
    required this.workspace,
    required this.memberId,
  });

  final Workspace workspace;
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _AmountCubit(),
      child: Builder(builder: (context) {
        return AlertDialog(
          title: const Text('Tambah saldo anggota'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            autofocus: true,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              hintText: 'Saldo',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
            onChanged: (value) {
              context.read<_AmountCubit>().setAmount(int.tryParse(value) ?? 0);
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            BlocListener<WorkspaceMemberByParentBloc,
                WorkspaceMemberByParentState>(
              listener: (context, state) {
                if (state is WorkspaceMemberByParentSuccess) {
                  context.read<WorkspaceMemberByParentBloc>().add(
                        FetchWorkspaceMemberByParent(
                          memberId: memberId,
                          workspaceId: workspace.id,
                        ),
                      );
                  GetIt.I<FlashMessageHelper>()
                      .showTopFlash('Berhasil perbaharui saldo');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: TextButton(
                child: const Text('Simpan'),
                onPressed: () {
                  final amount = context.read<_AmountCubit>().state;
                  context.read<WorkspaceMemberByParentBloc>().add(
                        SetBalanceWorkspaceMemberByParent(
                          memberId: memberId,
                          workspaceId: workspace.id,
                          amount: amount,
                        ),
                      );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
