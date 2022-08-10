import 'package:json_annotation/json_annotation.dart';
import 'package:kassku_mobile/models/role.dart';
import 'package:kassku_mobile/models/user.dart';

part 'member_workspace.g.dart';

@JsonSerializable(explicitToJson: true)
class MemberWorkspace {
  MemberWorkspace(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.parents,
    this.parent,
    this.balance,
    this.userId,
    this.role,
  );

  /// Converter from response map data to model
  factory MemberWorkspace.fromJson(Map<String, dynamic> json) =>
      _$MemberWorkspaceFromJson(json);

  /// Converter from model to map data for request
  Map<String, dynamic> toJson() => _$MemberWorkspaceToJson(this);

  @JsonKey(name: 'member_workspace_id')
  final String id;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  final String username;

  final String? email;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'role_workspace')
  final Role role;

  final List<MemberWorkspace>? parents;

  final User? parent;

  final int? balance;
}
