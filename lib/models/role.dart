import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable(explicitToJson: true)
class Role {
  Role(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.name,
    this.parentRoleId,
  );

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);

  final String id;

  final String name;

  final String description;

  @JsonKey(name: 'parent_role_id')
  final String? parentRoleId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
}
