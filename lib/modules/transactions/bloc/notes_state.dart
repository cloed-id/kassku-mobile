part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState(this.notes);

  final List<Note> notes;

  @override
  List<Object> get props => [notes];
}

class NotesInitial extends NotesState {
  NotesInitial() : super([]);
}

class NotesLoading extends NotesState {
  NotesLoading(NotesState state) : super(state.notes);
}

class NotesLoaded extends NotesState {
  const NotesLoaded(super.notes);
}

class NotesCreated extends NotesState {
  const NotesCreated(super.notes);
}

class NotesError extends NotesState {
  NotesError(NotesState state, this.message)
      : super(state.notes);

  final String message;
}
