import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kassku_mobile/models/note.dart';
import 'package:kassku_mobile/repositories/notes_repository.dart';
import 'package:kassku_mobile/utils/wrappers/error_wrapper.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(this.workspaceId) : super(NotesInitial()) {
    on<FetchNotes>(_searchNotes);
    on<CreateNote>(_createNote);
    on<DeleteNote>(_deleteNote);
  }

  final _repo = NotesRepository();
  final String workspaceId;

  Future<void> _deleteNote(
    DeleteNote event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading(state));
    await ErrorWrapper.asyncGuard(
      () => _repo.deleteNote(event.note.id, workspaceId),
      onError: (_) {
        emit(NotesLoaded(state.notes));
      },
    );

    final notes =
        state.notes.where((note) => note.id != event.note.id).toList();

    emit(NotesLoaded(notes));
  }

  Future<void> _searchNotes(
    FetchNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () => _repo.getNotes(event.key, workspaceId, event.memberWorkspaceId),
      onError: (_) {
        emit(NotesError(state, 'Error loading notes'));
      },
    );

    final data = result.data as List<Note>;

    emit(NotesLoaded(data));
  }

  Future<void> _createNote(
    CreateNote event,
    Emitter<NotesState> emit,
  ) async {
    emit(NotesLoading(state));
    final result = await ErrorWrapper.asyncGuard(
      () =>
          _repo.createNote(workspaceId, event.content, event.memberWorkspaceId),
      onError: (_) {
        emit(NotesLoaded(state.notes));
      },
    );

    final data = result.data as Note;

    emit(NotesCreated([data, ...state.notes]));

    add(FetchNotes(key: '', memberWorkspaceId: event.memberWorkspaceId));
  }
}
