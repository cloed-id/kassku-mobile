import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/modules/transactions/bloc/workspaces_bloc.dart';

class FormWorkspaceWidget extends StatelessWidget {
  const FormWorkspaceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var name = '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buat Area Kerja',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Masukan nama area kerja...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(color: Colors.black54),
              ),
            ),
            onChanged: (value) {
              name = value;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: BlocBuilder<WorkspacesBloc, WorkspacesState>(
              builder: (context, state) {
                if (state is WorkspacesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                return ElevatedButton(
                  onPressed: () {
                    if (name.isEmpty) {
                      GetIt.I<FlashMessageHelper>().showError(
                        'Area kerja tidak boleh kosong',
                      );
                    }

                    context
                        .read<WorkspacesBloc>()
                        .add(CreateWorkspace(name: name));
                  },
                  child: const Text('Buat Area Kerja'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
