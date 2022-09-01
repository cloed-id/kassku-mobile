import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/modules/transactions/bloc/notes_bloc.dart';

class FormNoteWidget extends StatelessWidget {
  const FormNoteWidget({
    super.key,
    required this.memberWorkspaceId,
  });

  final String memberWorkspaceId;

  @override
  Widget build(BuildContext context) {
    var content = '';

    return BlocListener<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesCreated) {
          Navigator.of(context).pop();
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buat Catatan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Masukan catatan...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
              onChanged: (value) {
                content = value;
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: BlocBuilder<NotesBloc, NotesState>(
                builder: (context, state) {
                  if (state is NotesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ElevatedButton(
                    onPressed: () {
                      if (content.isEmpty) {
                        GetIt.I<FlashMessageHelper>().showError(
                          'Catatan tidak boleh kosong',
                        );
                      }

                      context.read<NotesBloc>().add(
                            CreateNote(
                              content: content,
                              memberWorkspaceId: memberWorkspaceId,
                            ),
                          );
                    },
                    child: const Text('Buat Catatan'),
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
