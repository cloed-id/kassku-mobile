part of 'workspace_member_by_parent_bloc.dart';

abstract class WorkspaceMemberByParentState extends Equatable {
  const WorkspaceMemberByParentState(this.memberWorkspaces);

  final List<MemberWorkspace> memberWorkspaces;

  @override
  List<Object> get props => [];
}

class WorkspaceMemberByParentInitial extends WorkspaceMemberByParentState {
  WorkspaceMemberByParentInitial() : super([]);
}

class WorkspaceMemberByParentLoading extends WorkspaceMemberByParentState {
  WorkspaceMemberByParentLoading(WorkspaceMemberByParentState state)
      : super(state.memberWorkspaces);
}

class WorkspaceMemberByParentLoaded extends WorkspaceMemberByParentState {
  const WorkspaceMemberByParentLoaded(super.memberWorkspaces);
}

class WorkspaceMemberByParentSetBalanceSuccess extends WorkspaceMemberByParentState {
  const WorkspaceMemberByParentSetBalanceSuccess(super.memberWorkspaces);
}

class WorkspaceMemberByParentSuccess extends WorkspaceMemberByParentState {
  const WorkspaceMemberByParentSuccess(super.memberWorkspaces);
}

class WorkspaceMemberByParentError extends WorkspaceMemberByParentState {
  WorkspaceMemberByParentError(WorkspaceMemberByParentState state, this.message)
      : super(state.memberWorkspaces);

  final String message;
}
