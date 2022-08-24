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

class FormAddMemberWidget extends StatelessWidget {
  const FormAddMemberWidget({super.key, required this.onAddSuccess});

  final VoidCallback onAddSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _SelectedRoleCubit(),
      child: _FormAddMemberBodyWidget(onAddSuccess: onAddSuccess),
    );
  }
}

class _FormAddMemberBodyWidget extends StatelessWidget {
  const _FormAddMemberBodyWidget({super.key, required this.onAddSuccess});

  final VoidCallback onAddSuccess;

  @override
  Widget build(BuildContext context) {
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
          onAddSuccess.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final role = context.read<_SelectedRoleCubit>().state;
                  final workspace =
                      context.read<WorkspacesBloc>().state.selected;

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

                  context.read<WorkspaceMemberByParentBloc>().add(
                        CreateWorkspaceMemberByParent(
                          username: username,
                          role: role,
                          workspaceId: workspace.id,
                        ),
                      );
                },
                child: const Text('Tambah anggota'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}