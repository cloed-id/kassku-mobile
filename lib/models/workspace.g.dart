// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workspace _$WorkspaceFromJson(Map<String, dynamic> json) => Workspace(
      json['id'] as String,
      DateTime.parse(json['created_at'] as String),
      DateTime.parse(json['updated_at'] as String),
      json['description'] as String?,
      json['name'] as String,
      User.fromJson(json['admin'] as Map<String, dynamic>),
      (json['members'] as List<dynamic>)
          .map((e) => MemberWorkspace.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['member_workspace_id'] as String,
      json['balance'] as num?,
      json['role'] as String?,
    );

Map<String, dynamic> _$WorkspaceToJson(Workspace instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'admin': instance.admin.toJson(),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'member_workspace_id': instance.memberWorkspaceId,
      'balance': instance.balance,
      'role': instance.role,
    };
