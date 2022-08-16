import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';
import 'package:kassku_mobile/modules/transactions/view/main_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              WorkspacesBloc()..add(const FetchWorkspaces(key: '')),
        ),
      ],
      child: const MainScreen(),
    );
  }
}
