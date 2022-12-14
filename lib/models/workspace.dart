import 'package:json_annotation/json_annotation.dart';
import 'package:kassku_mobile/models/member_workspace.dart';
import 'package:kassku_mobile/models/user.dart';

part 'workspace.g.dart';

@JsonSerializable(explicitToJson: true)
class Workspace {
  Workspace(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.name,
    this.sumBalanceMember,
    this.admin,
    this.members,
    this.memberWorkspaceId,
    this.balance,
    this.role,
    this.permissions,
  );

  factory Workspace.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceFromJson(json);

  Map<String, dynamic> toJson() => _$WorkspaceToJson(this);

  final String id;

  final String name;

  final String? description;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(name: 'sum_balance_members')
  final int? sumBalanceMember;

  final User admin;

  final List<MemberWorkspace> members;

  @JsonKey(name: 'member_workspace_id')
  final String memberWorkspaceId;

  final num? balance;

  final String? role;

  final List<String> permissions;
}
