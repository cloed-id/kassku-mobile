// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kassku_mobile/modules/transactions/bloc/notes_bloc.dart';
import 'package:kassku_mobile/modules/transactions/view/widgets/form_note_dialog.dart';
import 'package:kassku_mobile/utils/extensions/string_extension.dart';
import 'package:kassku_mobile/utils/extensions/widget_extension.dart';

class NoteListWidget extends StatelessWidget {
  const NoteListWidget({
    super.key,
    required this.workspaceId,
    required this.memberWorkspaceId,
  });

  final String workspaceId;
  final String memberWorkspaceId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(workspaceId)
        ..add(FetchNotes(key: '', memberWorkspaceId: memberWorkspaceId)),
      child: _NoteList(memberWorkspaceId: memberWorkspaceId),
    );
  }
}

class _NoteList extends StatelessWidget {
  const _NoteList({super.key, required this.memberWorkspaceId});

  final String memberWorkspaceId;

  void _onAddPressed(BuildContext context, String memberWorkspaceId) {
    BlocProvider.value(
      value: BlocProvider.of<NotesBloc>(context),
      child: FormNoteWidget(
        memberWorkspaceId: memberWorkspaceId,
      ),
    ).showCustomDialog<void>(context);
  }

  @override
  Widget build(BuildContext context) {
    final notesState = context.watch<NotesBloc>().state;
    if (notesState is NotesError) {
      return Center(
        child: Text(notesState.message),
      );
    }
    if (notesState is NotesLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (notesState is NotesLoaded) {
      if (notesState.notes.isEmpty) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Text(
                  'Tidak ada catatan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _onAddPressed(context, memberWorkspaceId),
                child: const Text('silahkan buat'),
              )
            ],
          ),
        );
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              children: [
                const Text(
                  'Catatan kamu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => _onAddPressed(context, memberWorkspaceId),
                  icon: const Icon(Icons.note_add_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: notesState.notes.length + 1,
                itemBuilder: (context, index) {
                  if (index == notesState.notes.length) {
                    return const SizedBox(height: 24);
                  }

                  final note = notesState.notes[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(note.textContent.originalText),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            final noteBloc =
                                BlocProvider.of<NotesBloc>(context);
                            showDialog<void>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  'Hapus catatan',
                                ),
                                content: RichText(
                                  text: TextSpan(
                                    text:
                                        'Apakah anda yakin menghapus catatan\n\n',
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: note.textContent.originalText
                                            .capitalize,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const TextSpan(
                                        text: '?',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      noteBloc.add(DeleteNote(note: note));
                                    },
                                    child: const Text('Ya'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Tidak'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
