import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/models/member_workspace.dart';
import 'package:kassku_mobile/models/workspace.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspace_member_by_parent_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';
import 'package:kassku_mobile/utils/extensions/string_extension.dart';
import 'package:kassku_mobile/utils/extensions/widget_extension.dart';
import 'package:kassku_mobile/utils/functions.dart';
import 'package:kassku_mobile/widgets/form_add_member_widget.dart';

class ListMemberWidget extends StatelessWidget {
  const ListMemberWidget({
    super.key,
    required this.label,
    required this.members,
    required this.workspace,
    required this.onAddSuccess,
    this.ableToSetBalance = false,
  });

  final String label;
  final bool ableToSetBalance;
  final List<MemberWorkspace> members;
  final Workspace workspace;
  final VoidCallback onAddSuccess;

  void _openAddMemberDialog(BuildContext context) {
    final workspaceMemberByParentBloc =
        BlocProvider.of<WorkspaceMemberByParentBloc>(context);
    final workspacesBloc = BlocProvider.of<WorkspacesBloc>(context);
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: workspaceMemberByParentBloc),
        BlocProvider.value(value: workspacesBloc)
      ],
      child: FormAddMemberWidget(onAddSuccess: onAddSuccess),
    ).showCustomDialog<void>(context);
  }

  void _onSetBalance(BuildContext context, String memberId) {
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
          memberId: memberId,
        ),
      ),
    );
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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                final isYou = member.id == workspace.memberWorkspaceId;
                var title = member.username.capitalize;

                if (isYou) {
                  title += ' - ( Anda )';
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      isThreeLine: true,
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
                      subtitle: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              roleToDisplay(member.role.name),
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              member.balance != null
                                  ? currencyFormatter.format(member.balance)
                                  : 'Saldo belum di set',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          switch (value) {
                            case 'set_amount':
                              if (ableToSetBalance) {
                                _onSetBalance(context, member.id);
                              }
                          }
                        },
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) {
                          return [
                            if (ableToSetBalance)
                              PopupMenuItem<String>(
                                value: 'set_amount',
                                child: Row(
                                  children: const [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Tambah Saldo'),
                                  ],
                                ),
                              ),
                          ];
                        },
                      ),
                      onTap: () => ableToSetBalance
                          ? _onSetBalance(context, member.id)
                          : null,
                    ),
                  ),
                );
              },
            ),
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
      child: Builder(
        builder: (context) {
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
                context
                    .read<_AmountCubit>()
                    .setAmount(int.tryParse(value) ?? 0);
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
        },
      ),
    );
  }
}
