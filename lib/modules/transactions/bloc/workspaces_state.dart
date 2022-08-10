part of 'workspaces_bloc.dart';

abstract class WorkspacesState extends Equatable {
  const WorkspacesState(this.workspaces, this.selected);

  final List<Workspace> workspaces;
  final Workspace? selected;

  @override
  List<Object?> get props => [workspaces];
}

class WorkspacesInitial extends WorkspacesState {
  WorkspacesInitial() : super([], null);
}

class WorkspacesLoading extends WorkspacesState {
  WorkspacesLoading(WorkspacesState state)
      : super(state.workspaces, state.selected);
}

class WorkspacesLoaded extends WorkspacesState {
  const WorkspacesLoaded(super.workspaces, super.selected);
}

class WorkspacesSuccess extends WorkspacesState {
  const WorkspacesSuccess(super.workspaces, super.selected);
}
class WorkspacesSelected extends WorkspacesState {
  const WorkspacesSelected(super.workspaces, super.selected);
}

class WorkspacesError extends WorkspacesState {
  WorkspacesError(WorkspacesState state, this.message)
      : super(state.workspaces, state.selected);

  final String message;
}
