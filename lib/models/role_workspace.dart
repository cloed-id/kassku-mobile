import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role_workspace.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2)
class RoleWorkspace extends HiveObject {
  RoleWorkspace(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.roleId,
    this.userId,
    this.workspaceId,
    this.roleName,
    this.workspaceName,
  );

  factory RoleWorkspace.fromJson(Map<String, dynamic> json) =>
      _$RoleWorkspaceFromJson(json);

  Map<String, dynamic> toJson() => _$RoleWorkspaceToJson(this);

  @HiveField(0)
  final String id;

  @HiveField(1)
  @JsonKey(name: 'role_id')
  final String roleId;

  @HiveField(2)
  @JsonKey(name: 'user_id')
  final String userId;

  @HiveField(3)
  @JsonKey(name: 'workspace_id')
  final String workspaceId;

  @HiveField(4)
  @JsonKey(name: 'role_name')
  final String roleName;

  @HiveField(5)
  @JsonKey(name: 'workspace_name')
  final String workspaceName;

  @HiveField(6)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @HiveField(7)
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
}
