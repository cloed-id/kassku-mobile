part of 'workspace_member_by_parent_bloc.dart';

abstract class WorkspaceMemberByParentEvent extends Equatable {
  const WorkspaceMemberByParentEvent();
}

class FetchWorkspaceMemberByParent extends WorkspaceMemberByParentEvent {
  const FetchWorkspaceMemberByParent({
    required this.workspaceId,
    required this.memberId,
  });

  final String workspaceId;
  final String memberId;

  @override
  List<Object> get props => [workspaceId, memberId];
}
