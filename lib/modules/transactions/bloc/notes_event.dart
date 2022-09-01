part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
}

class SelectNote extends NotesEvent {
  const SelectNote(this.note);

  final Note note;

  @override
  List<Object?> get props => [note];
}

class FetchNotes extends NotesEvent {
  const FetchNotes({
    required this.key,
    required this.memberWorkspaceId,
  });

  final String key;
  final String memberWorkspaceId;

  @override
  List<Object> get props => [key, memberWorkspaceId];
}

class CreateNote extends NotesEvent {
  const CreateNote({
    required this.content,
    required this.memberWorkspaceId,
  });

  final String content;
  final String memberWorkspaceId;

  @override
  List<Object> get props => [content, memberWorkspaceId];
}

class DeleteNote extends NotesEvent {
  const DeleteNote({required this.note});

  final Note note;

  @override
  List<Object> get props => [note];
}
