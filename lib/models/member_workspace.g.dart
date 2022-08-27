// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberWorkspace _$MemberWorkspaceFromJson(Map<String, dynamic> json) =>
    MemberWorkspace(
      json['member_workspace_id'] as String,
      DateTime.parse(json['created_at'] as String),
      DateTime.parse(json['updated_at'] as String),
      json['username'] as String,
      json['email'] as String?,
      json['first_name'] as String?,
      json['last_name'] as String?,
      (json['parents'] as List<dynamic>?)
          ?.map((e) => MemberWorkspace.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['parent'] == null
          ? null
          : User.fromJson(json['parent'] as Map<String, dynamic>),
      json['balance'] as int?,
      json['user_id'] as String,
      Role.fromJson(json['role_workspace'] as Map<String, dynamic>),
      (json['permissions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MemberWorkspaceToJson(MemberWorkspace instance) =>
    <String, dynamic>{
      'member_workspace_id': instance.id,
      'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'role_workspace': instance.role.toJson(),
      'parents': instance.parents?.map((e) => e.toJson()).toList(),
      'parent': instance.parent?.toJson(),
      'balance': instance.balance,
      'permissions': instance.permissions,
    };
