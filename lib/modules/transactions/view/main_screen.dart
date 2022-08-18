// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/category.dart';
import 'package:kassku_mobile/models/member_workspace.dart';
import 'package:kassku_mobile/models/workspace.dart';
import 'package:kassku_mobile/modules/transactions/bloc/categories_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/transactions_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspace_member_by_parent_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';
import 'package:kassku_mobile/modules/transactions/view/widgets/category_list_widget.dart';
import 'package:kassku_mobile/modules/transactions/view/widgets/form_add_member_dialog.dart';
import 'package:kassku_mobile/modules/transactions/view/widgets/transaction_list_widget.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/extensions/string_extension.dart';
import 'package:kassku_mobile/utils/extensions/widget_extension.dart';
import 'package:kassku_mobile/utils/functions.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'package:kassku_mobile/modules/transactions/view/widgets/form_workspace_dialog.dart';
part 'package:kassku_mobile/modules/transactions/view/widgets/form_transaction_dialog.dart';
part 'package:kassku_mobile/modules/transactions/view/widgets/list_member_dialog.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<UserHelper>().getUser();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaksi Anda'),
            BlocBuilder<WorkspacesBloc, WorkspacesState>(
              builder: (context, state) {
                if (state is WorkspacesLoaded &&
                    state.selected != null &&
                    state.selected!.balance != null) {
                  return Text(
                    'Saldo: ${currencyFormatterNoLeading.format(state.selected!.balance)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: ColorName.primary,
                backgroundBlendMode: BlendMode.darken,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://picsum.photos/250',
                  ),
                  opacity: 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user != null
                            ? user.username.capitalize
                            : 'Kassku Mobile',
                        style: const TextStyle(
                          color: ColorName.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              'v${snapshot.data!.version}',
                              style: const TextStyle(color: ColorName.white),
                            );
                          }

                          return const SizedBox();
                        },
                      )
                    ],
                  ),
                  const Spacer(),
                  BlocBuilder<WorkspacesBloc, WorkspacesState>(
                    builder: (context, state) {
                      if (state is WorkspacesLoaded) {
                        if (state.workspaces.isEmpty) return const SizedBox();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Area Kerja',
                                  style: TextStyle(color: ColorName.white),
                                ),
                                const SizedBox(width: 4),
                                InkWell(
                                  child: const Icon(
                                    Icons.add,
                                    color: ColorName.white,
                                  ),
                                  onTap: () {
                                    final workspaceBloc =
                                        context.read<WorkspacesBloc>();
                                    BlocProvider.value(
                                      value: workspaceBloc,
                                      child: const _FormWorkspaceDialog(),
                                    ).showCustomDialog<void>(context);
                                  },
                                )
                              ],
                            ),
                            DropdownButton<String?>(
                              value: state.selected?.memberWorkspaceId,
                              style: const TextStyle(
                                color: ColorName.white,
                                fontWeight: FontWeight.bold,
                              ),
                              isExpanded: true,
                              dropdownColor: ColorName.secondary,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: ColorName.white,
                              ),
                              underline: const SizedBox(),
                              items: state.workspaces
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.memberWorkspaceId,
                                      child: _DropdownItem(e: e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) {
                                  return;
                                }

                                final workspace = state.workspaces.firstWhere(
                                  (e) => e.memberWorkspaceId == value,
                                );

                                context
                                    .read<WorkspacesBloc>()
                                    .add(SelectWorkspace(workspace: workspace));
                              },
                            ),
                          ],
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
            BlocBuilder<WorkspacesBloc, WorkspacesState>(
              builder: (context, state) {
                if (state is WorkspacesLoaded && state.selected != null) {
                  if (state.selected!.role == 'admin') {
                    return ListTile(
                      leading: const Icon(Icons.category),
                      title: const Text('Kategori'),
                      onTap: () {
                        CategoryListWidget(
                          workspaceId: state.selected!.id,
                        ).showSheet<void>(context);
                      },
                    );
                  }
                }
                return const SizedBox();
              },
            ),
            BlocBuilder<WorkspacesBloc, WorkspacesState>(
              builder: (context, workspaceState) {
                if (workspaceState is WorkspacesLoaded &&
                    workspaceState.selected != null &&
                    workspaceState.selected!.role != 'finance' &&
                    workspaceState.selected!.role != 'observer') {
                  return BlocProvider(
                    create: (context) => WorkspaceMemberByParentBloc()
                      ..add(
                        FetchWorkspaceMemberByParent(
                          workspaceId: workspaceState.selected!.id,
                          memberId: workspaceState.selected!.memberWorkspaceId,
                        ),
                      ),
                    child: BlocBuilder<WorkspaceMemberByParentBloc,
                        WorkspaceMemberByParentState>(
                      builder: (context, workspaceMemberState) {
                        return ListTile(
                          leading: const Icon(Icons.people_alt_outlined),
                          title: const Text('Anggota Anda'),
                          onTap: () {
                            final workspaceMemberByParentBloc =
                                BlocProvider.of<WorkspaceMemberByParentBloc>(
                              context,
                            );
                            final workspacesBloc =
                                BlocProvider.of<WorkspacesBloc>(context);
                            MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: workspaceMemberByParentBloc,
                                ),
                                BlocProvider.value(value: workspacesBloc)
                              ],
                              child: _ListMemberDialog(
                                label: 'Anggota Anda',
                                members: workspaceMemberState.memberWorkspaces,
                                workspace: workspaceState.selected!,
                                ableToSetBalance: true,
                              ),
                            ).showSheet<void>(context);
                          },
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            BlocBuilder<WorkspacesBloc, WorkspacesState>(
              builder: (context, state) {
                if (state is WorkspacesLoaded && state.selected != null) {
                  return ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Anggota Area Kerja'),
                    onTap: () {
                      _ListMemberDialog(
                        label:
                            'Anggota Area Kerja ${state.selected!.name.capitalizeFirstOfEach}',
                        members: state.selected!.members,
                        workspace: state.selected!,
                      ).showSheet<void>(context);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
            BlocBuilder<WorkspacesBloc, WorkspacesState>(
              builder: (context, state) {
                if (state is WorkspacesLoaded && state.selected != null) {
                  return ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Transaksi Anggota'),
                    onTap: () {
                      MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => TransactionsBloc()
                              ..add(
                                FetchTransactions(
                                  state.selected!.id,
                                  null,
                                  key: '',
                                ),
                              ),
                          ),
                          BlocProvider.value(
                            value: BlocProvider.of<WorkspacesBloc>(context),
                          )
                        ],
                        child: const TransactionsListWidget(
                          isWorkspaceTransactions: true,
                        ),
                      ).showSheet<void>(context);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
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
          if (state is WorkspacesCreated) {
            GetIt.I<FlashMessageHelper>()
                .showTopFlash('Area kerja berhasil dibuat');
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
                      'Tidak ada area kerja,',
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
                      child: const Text('silahkan buat'),
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

                      Navigator.of(context).pop();
                    }
                  },
                  child: const TransactionsListWidget(),
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

class _DropdownItem extends StatelessWidget {
  const _DropdownItem({super.key, required this.e});

  final Workspace e;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.name.capitalize),
                if (e.balance != null)
                  Text(
                    'Saldo: ${currencyFormatterNoLeading.format(e.balance)}',
                    style: const TextStyle(
                      color: ColorName.white,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (e.role != null)
                  Text(
                    e.role!.capitalize,
                    style: const TextStyle(
                      color: ColorName.white,
                      fontSize: 11,
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.people,
                      color: ColorName.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      e.members.length.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
