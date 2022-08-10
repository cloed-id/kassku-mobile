part of 'workspaces_bloc.dart';

abstract class WorkspacesEvent extends Equatable {
  const WorkspacesEvent();
}

class FetchWorkspaces extends WorkspacesEvent {
  const FetchWorkspaces({required this.key});

  final String key;

  @override
  List<Object> get props => [key];
}

class CreateWorkspace extends WorkspacesEvent {
  const CreateWorkspace({required this.name});

  final String name;

  @override
  List<Object> get props => [name];
}

class SelectWorkspace extends WorkspacesEvent {
  const SelectWorkspace({required this.workspace});

  final Workspace workspace;

  @override
  List<Object> get props => [workspace];
}
