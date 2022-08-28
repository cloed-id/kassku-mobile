import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspace_member_by_parent_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';

class _SelectedRoleCubit extends Cubit<String?> {
  _SelectedRoleCubit() : super(null);

  void change(String role) => emit(role);
}

class _SelectedPermissionsCubit extends Cubit<List<String>> {
  _SelectedPermissionsCubit() : super([]);

  void addPermission(String permission) => emit([...state, permission]);

  void removePermission(String permission) {
    final index = state.indexOf(permission);

    final list = state.toList()..removeAt(index);

    emit(list);
  }
}

class FormAddMemberWidget extends StatelessWidget {
  const FormAddMemberWidget({super.key, required this.onAddSuccess});

  final VoidCallback? onAddSuccess;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _SelectedRoleCubit(),
        ),
        BlocProvider(
          create: (context) => _SelectedPermissionsCubit(),
        ),
      ],
      child: _FormAddMemberBodyWidget(onAddSuccess: onAddSuccess),
    );
  }
}

class _FormAddMemberBodyWidget extends StatelessWidget {
  const _FormAddMemberBodyWidget({super.key, required this.onAddSuccess});

  final VoidCallback? onAddSuccess;

  @override
  Widget build(BuildContext context) {
    const createExpenseId = '00000002-0000-0000-0000-200000000000';
    const createIncomeId = '00000002-0000-0000-0000-200000000001';

    final workspace = context.watch<WorkspacesBloc>().state.selected;

    if (workspace == null) {
      return const Center(
        child: Text('Workspace not selected'),
      );
    }

    var username = '';

    return BlocListener<WorkspaceMemberByParentBloc,
        WorkspaceMemberByParentState>(
      listener: (context, state) {
        if (state is WorkspaceMemberByParentSuccess) {
          context.read<WorkspacesBloc>().add(const FetchWorkspaces(key: ''));
          onAddSuccess?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Formulir tambah anggota',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Masukan username anggota...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(color: Colors.black54),
                  ),
                ),
                onChanged: (value) {
                  username = value;
                },
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorName.secondaryContainer,
                ),
                child: const Text(
                  'Password member baru sama dengan username',
                  style: TextStyle(
                    color: ColorName.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Jenis Anggota',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  BlocBuilder<_SelectedRoleCubit, String?>(
                    builder: (context, state) {
                      return DropdownButton<String>(
                        value: state,
                        hint: const Text('Pilih jenis anggota'),
                        underline: const SizedBox(),
                        items: [
                          if (workspace.role == 'admin')
                            const DropdownMenuItem(
                              value: 'head',
                              child: Text('Kepala'),
                            ),
                          if (workspace.role == 'head')
                            const DropdownMenuItem(
                              value: 'finance',
                              child: Text('Bendahara'),
                            ),
                          if (workspace.role == 'admin')
                            const DropdownMenuItem(
                              value: 'observer',
                              child: Text('Pengamat'),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            context.read<_SelectedRoleCubit>().change(value);
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BlocBuilder<_SelectedRoleCubit, String?>(
                builder: (context, state) {
                  if (state == null || state == 'observer') {
                    return const SizedBox();
                  }

                  return BlocBuilder<_SelectedPermissionsCubit, List<String>>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Izin',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Berikan izin transaksi pada anggota anda...',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          CheckboxListTile(
                            activeColor: ColorName.primary,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            value: state.contains(createIncomeId),
                            title: const Text('Pembuatan Pemasukan'),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              const strValue = createIncomeId;

                              if (value) {
                                context
                                    .read<_SelectedPermissionsCubit>()
                                    .addPermission(strValue);
                              } else {
                                context
                                    .read<_SelectedPermissionsCubit>()
                                    .removePermission(strValue);
                              }
                            },
                          ),
                          CheckboxListTile(
                            activeColor: ColorName.primary,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            value: state.contains(createExpenseId),
                            title: const Text('Pembuatan Pengeluaran'),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }

                              const strValue = createExpenseId;

                              if (value) {
                                context
                                    .read<_SelectedPermissionsCubit>()
                                    .addPermission(strValue);
                              } else {
                                context
                                    .read<_SelectedPermissionsCubit>()
                                    .removePermission(strValue);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<WorkspaceMemberByParentBloc,
                  WorkspaceMemberByParentState>(
                builder: (context, workspaceByParentState) {
                  if (workspaceByParentState
                      is WorkspaceMemberByParentLoading) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 35,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final role = context.read<_SelectedRoleCubit>().state;
                        final workspace =
                            context.read<WorkspacesBloc>().state.selected;
                        final permissionIds =
                            context.read<_SelectedPermissionsCubit>().state;

                        if (username.isEmpty) {
                          GetIt.I<FlashMessageHelper>().showError(
                            'Username tidak boleh kosong',
                          );
                          return;
                        }

                        if (role == null) {
                          GetIt.I<FlashMessageHelper>().showError(
                            'Jenis anggota belum dipilih',
                          );
                          return;
                        }

                        if (workspace == null) {
                          GetIt.I<FlashMessageHelper>().showError(
                            'Workspace belum dipilih',
                          );
                          return;
                        }

                        if (permissionIds.isEmpty &&
                            (role == 'head' || role == 'finance')) {
                          return GetIt.I<FlashMessageHelper>().showError(
                            'Izin anggota belum dipilih',
                          );
                        }

                        context.read<WorkspaceMemberByParentBloc>().add(
                              CreateWorkspaceMemberByParent(
                                username: username,
                                role: role,
                                workspaceId: workspace.id,
                                permissionIds: permissionIds,
                              ),
                            );
                      },
                      child: const Text('Tambah anggota'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
