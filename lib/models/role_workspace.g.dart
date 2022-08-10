// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_workspace.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoleWorkspaceAdapter extends TypeAdapter<RoleWorkspace> {
  @override
  final int typeId = 2;

  @override
  RoleWorkspace read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoleWorkspace(
      fields[0] as String,
      fields[6] as DateTime,
      fields[7] as DateTime,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RoleWorkspace obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roleId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.workspaceId)
      ..writeByte(4)
      ..write(obj.roleName)
      ..writeByte(5)
      ..write(obj.workspaceName)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleWorkspaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleWorkspace _$RoleWorkspaceFromJson(Map<String, dynamic> json) =>
    RoleWorkspace(
      json['id'] as String,
      DateTime.parse(json['created_at'] as String),
      DateTime.parse(json['updated_at'] as String),
      json['role_id'] as String,
      json['user_id'] as String,
      json['workspace_id'] as String,
      json['role_name'] as String,
      json['workspace_name'] as String,
    );

Map<String, dynamic> _$RoleWorkspaceToJson(RoleWorkspace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role_id': instance.roleId,
      'user_id': instance.userId,
      'workspace_id': instance.workspaceId,
      'role_name': instance.roleName,
      'workspace_name': instance.workspaceName,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
