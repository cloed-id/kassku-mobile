// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/models/category.dart';
import 'package:kassku_mobile/models/workspace.dart';
import 'package:kassku_mobile/modules/transactions/bloc/categories_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/transactions_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspace_member_by_parent_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';
import 'package:kassku_mobile/modules/transactions/view/widgets/category_list_widget.dart';
import 'package:kassku_mobile/modules/transactions/view/widgets/transaction_chart_widget.dart';
import 'package:kassku_mobile/modules/transactions/view/widgets/transaction_list_widget.dart';
import 'package:kassku_mobile/modules/tutorial/view/tutorial_page.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/extensions/string_extension.dart';
import 'package:kassku_mobile/utils/extensions/widget_extension.dart';
import 'package:kassku_mobile/utils/functions.dart';
import 'package:kassku_mobile/widgets/form_workspace_widget.dart';
import 'package:kassku_mobile/widgets/list_member_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'package:kassku_mobile/modules/transactions/view/widgets/form_transaction_dialog.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = GetIt.I<UserHelper>().getUser();
    final workspacesState = context.watch<WorkspacesBloc>().state;

    return BlocProvider(
      create: (context) => TransactionsBloc()
        ..add(
          FetchTransactions(
            workspacesState.selected!.id,
            workspacesState.selected!.role == 'observer'
                ? null
                : workspacesState.selected!.memberWorkspaceId,
            key: '',
          ),
        ),
      child: Scaffold(
        backgroundColor: ColorName.background,
        appBar: AppBar(
          title: Builder(
            builder: (context) {
              if (workspacesState is WorkspacesLoaded &&
                  workspacesState.selected != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workspacesState.selected!.role != 'observer'
                          ? 'Transaksi Anda'
                          : 'Transaksi Area Kerja',
                    ),
                    if (workspacesState.selected!.balance != null)
                      Text(
                        'Saldo: ${currencyFormatterNoLeading.format(workspacesState.selected!.balance)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                );
              }

              return const SizedBox();
            },
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
                                style: const TextStyle(
                                  color: ColorName.white,
                                  fontSize: 12,
                                ),
                              );
                            }

                            return const SizedBox();
                          },
                        )
                      ],
                    ),
                    const Spacer(),
                    Builder(
                      builder: (context) {
                        if (workspacesState is WorkspacesLoaded) {
                          if (workspacesState.workspaces.isEmpty) {
                            return const SizedBox();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Area Kerja',
                                    style: TextStyle(
                                      color: ColorName.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: ColorName.white,
                                    ),
                                    onPressed: () {
                                      final workspaceBloc =
                                          context.read<WorkspacesBloc>();
                                      BlocProvider.value(
                                        value: workspaceBloc,
                                        child: const FormWorkspaceWidget(),
                                      ).showCustomDialog<void>(context);
                                    },
                                  )
                                ],
                              ),
                              DropdownButton<String?>(
                                value:
                                    workspacesState.selected?.memberWorkspaceId,
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
                                items: workspacesState.workspaces
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

                                  final workspace =
                                      workspacesState.workspaces.firstWhere(
                                    (e) => e.memberWorkspaceId == value,
                                  );

                                  context.read<WorkspacesBloc>().add(
                                      SelectWorkspace(workspace: workspace));
                                },
                              ),
                            ],
                          );
                        } else if (workspacesState is WorkspacesError) {
                          return Text(
                            workspacesState.message,
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
              Builder(
                builder: (context) {
                  if (workspacesState is WorkspacesLoaded &&
                      workspacesState.selected != null) {
                    if (workspacesState.selected!.role == 'admin') {
                      return ListTile(
                        leading: const Icon(Icons.bar_chart),
                        title: const Text('Grafik Transaksi'),
                        onTap: () {
                          TransactionChartWidget(
                            workspaceId: workspacesState.selected!.id,
                          ).showSheet<void>(context);
                        },
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
              Builder(
                builder: (context) {
                  if (workspacesState is WorkspacesLoaded &&
                      workspacesState.selected != null) {
                    if (workspacesState.selected!.role == 'admin') {
                      return ListTile(
                        leading: const Icon(Icons.category),
                        title: const Text('Kategori'),
                        onTap: () {
                          CategoryListWidget(
                            workspaceId: workspacesState.selected!.id,
                          ).showSheet<void>(context);
                        },
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
              Builder(
                builder: (context) {
                  if (workspacesState is WorkspacesLoaded &&
                      workspacesState.selected != null &&
                      workspacesState.selected!.role != 'finance' &&
                      workspacesState.selected!.role != 'observer') {
                    return BlocProvider(
                      create: (context) => WorkspaceMemberByParentBloc()
                        ..add(
                          FetchWorkspaceMemberByParent(
                            workspaceId: workspacesState.selected!.id,
                            memberId:
                                workspacesState.selected!.memberWorkspaceId,
                          ),
                        ),
                      child: BlocConsumer<WorkspaceMemberByParentBloc,
                          WorkspaceMemberByParentState>(
                        listener: (context, workspaceMemberState) {
                          if (workspaceMemberState
                                  is WorkspaceMemberByParentSuccess ||
                              workspaceMemberState
                                  is WorkspaceMemberByParentSetBalanceSuccess) {
                            context.read<TransactionsBloc>().add(
                                  FetchTransactions(
                                    workspacesState.selected!.id,
                                    workspacesState.selected!.memberWorkspaceId,
                                    key: '',
                                  ),
                                );
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        },
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
                                child: ListMemberWidget(
                                  label: 'Anggota Anda',
                                  members:
                                      workspaceMemberState.memberWorkspaces,
                                  workspace: workspacesState.selected!,
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
              Builder(
                builder: (context) {
                  if (workspacesState is WorkspacesLoaded &&
                      workspacesState.selected != null) {
                    return ListTile(
                      leading: const Icon(Icons.people),
                      title: const Text('Anggota Area Kerja'),
                      subtitle: Text(
                        'Saldo: ${currencyFormatter.format(workspacesState.selected?.sumBalanceMember)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        ListMemberWidget(
                          label:
                              'Anggota Area Kerja ${workspacesState.selected!.name.capitalizeFirstOfEach}',
                          members: workspacesState.selected!.members,
                          workspace: workspacesState.selected!,
                          onAddSuccess: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ).showSheet<void>(context);
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              Builder(
                builder: (context) {
                  if (workspacesState is WorkspacesLoaded &&
                      workspacesState.selected != null &&
                      workspacesState.selected!.role != 'observer') {
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
                                    workspacesState.selected!.id,
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
              context
                  .read<WorkspacesBloc>()
                  .add(const FetchWorkspaces(key: ''));
              Navigator.pop(context);
            } else if (state is WorkspacesCalledTutorial) {
              Navigator.of(context)
                  .push(
                MaterialPageRoute<void>(
                  builder: (context) => const TutorialPage(),
                ),
              )
                  .then((value) {
                context
                    .read<WorkspacesBloc>()
                    .add(const FetchWorkspaces(key: ''));

                context.read<TransactionsBloc>().add(
                      FetchTransactions(
                        workspacesState.selected!.id,
                        workspacesState.selected!.memberWorkspaceId,
                        key: '',
                      ),
                    );
              });
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
                            child: const FormWorkspaceWidget(),
                          ).showCustomDialog<void>(context);
                        },
                        child: const Text('silahkan buat'),
                      )
                    ],
                  ),
                );
              }

              return Center(
                child: BlocListener<WorkspacesBloc, WorkspacesState>(
                  listener: (context, state) {
                    if (state is WorkspacesSelected) {
                      context.read<TransactionsBloc>().add(
                            FetchTransactions(
                              state.selected!.id,
                              state.selected!.role == 'observer'
                                  ? null
                                  : state.selected!.memberWorkspaceId,
                              key: '',
                            ),
                          );

                      Navigator.of(context).pop();
                    }
                  },
                  child: TransactionsListWidget(
                    isWorkspaceTransactions: state.selected!.role == 'observer',
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (e.role != null)
                  Text(
                    roleToDisplay(e.role!),
                    style: const TextStyle(
                      color: ColorName.white,
                      fontSize: 12,
                    ),
                  ),
                Text(
                  '${e.members.length.toString()} anggota',
                  style: const TextStyle(
                    color: ColorName.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
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
          ],
        ),
      ),
    );
  }
}
