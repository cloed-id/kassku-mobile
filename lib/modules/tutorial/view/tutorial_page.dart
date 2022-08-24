import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspace_member_by_parent_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';
import 'package:kassku_mobile/utils/functions.dart';
import 'package:kassku_mobile/widgets/form_workspace_widget.dart';
import 'package:kassku_mobile/widgets/list_member_widget.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          WorkspacesBloc()..add(const FetchWorkspaces(key: '')),
      child: const _TutorialBodyWidget(),
    );
  }
}

class _TutorialBodyWidget extends StatelessWidget {
  const _TutorialBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WorkspacesBloc, WorkspacesState>(
      listener: (context, state) {
        if (state is WorkspacesLoaded) {
          if (state.selected == null && state.workspaces.isNotEmpty) {
            context
                .read<WorkspacesBloc>()
                .add(SelectWorkspace(workspace: state.workspaces.first));
          }
        } else if (state is WorkspacesCreated) {
          GetIt.I<FlashMessageHelper>()
              .showTopFlash('Area kerja berhasil dibuat');
          context.read<WorkspacesBloc>().add(const FetchWorkspaces(key: ''));
        }
      },
      child: WillPopScope(
        onWillPop: () {
          final workspaces = context.read<WorkspacesBloc>().state.workspaces;
          final workspace = context.read<WorkspacesBloc>().state.selected;
          final isAbleToPop = workspaces.isNotEmpty &&
              workspace != null &&
              workspace.members.length > 1;

          if (!isAbleToPop) {
            showDialog<void>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Keluar aplikasi?'),
                  content: const Text('Anda yakin ingin keluar dari aplikasi?'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        GetIt.I<UserHelper>().logout();
                      },
                      child: const Text('Iya'),
                    ),
                    ElevatedButton(
                      child: const Text('Tidak'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }

          return Future.value(isAbleToPop);
        },
        child: Scaffold(
          body: SafeArea(
            child: BlocBuilder<WorkspacesBloc, WorkspacesState>(
              builder: (context, state) {
                if (state is WorkspacesLoaded) {
                  if (state.workspaces.isEmpty) {
                    return const FormWorkspaceWidget();
                  } else if (state.selected != null) {
                    final workspace = state.selected!;

                    return BlocProvider(
                      create: (context) => WorkspaceMemberByParentBloc()
                        ..add(
                          FetchWorkspaceMemberByParent(
                            workspaceId: workspace.id,
                            memberId: workspace.memberWorkspaceId,
                          ),
                        ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Area Kerja: ${workspace.name}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (workspace.role != null)
                              Text(
                                'Peran: ${roleToDisplay(workspace.role!)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Text(
                              '${workspace.members.length.toString()} anggota',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 14),
                            BlocBuilder<WorkspaceMemberByParentBloc,
                                WorkspaceMemberByParentState>(
                              builder: (context, state) {
                                return ListMemberWidget(
                                  label: 'Anggota Anda',
                                  members: state.memberWorkspaces,
                                  workspace: workspace,
                                  ableToSetBalance: true,
                                  onAddSuccess: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
