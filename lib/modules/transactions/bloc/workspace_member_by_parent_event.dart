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

class SetBalanceWorkspaceMemberByParent extends WorkspaceMemberByParentEvent {
  const SetBalanceWorkspaceMemberByParent({
    required this.role,
    required this.balanceType,
    required this.workspaceId,
    required this.memberId,
    required this.amount,
  });

  final String? role;
  final String balanceType;
  final String workspaceId;
  final String memberId;
  final int amount;

  @override
  List<Object> get props => [workspaceId, memberId, amount];
}

class CreateWorkspaceMemberByParent extends WorkspaceMemberByParentEvent {
  const CreateWorkspaceMemberByParent({
    required this.workspaceId,
    required this.username,
    required this.role,
    required this.permissionIds,
  });

  final String workspaceId;
  final String username;
  final String role;
  final List<String> permissionIds;

  @override
  List<Object> get props => [workspaceId, username];
}
