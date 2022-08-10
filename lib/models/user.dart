import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kassku_mobile/models/role_workspace.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 1)
class User extends HiveObject {
  User(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.rolesWorkspaces,
    this.parents,
  );

  /// Converter from response map data to model
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converter from model to map data for request
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? phone;

  @HiveField(2)
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @HiveField(3)
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @HiveField(4)
  final String username;

  @HiveField(5)
  final String? email;

  @HiveField(6)
  @JsonKey(name: 'first_name')
  final String? firstName;

  @HiveField(7)
  @JsonKey(name: 'last_name')
  final String? lastName;

  @HiveField(8)
  @JsonKey(name: 'roles_workspaces')
  final List<RoleWorkspace>? rolesWorkspaces;

  /// List of user's parents
  /// Multiple parent can be done in different workspaces
  @HiveField(9)
  final List<User>? parents;
}
