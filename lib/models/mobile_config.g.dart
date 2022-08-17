// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobile_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MobileConfigAdapter extends TypeAdapter<MobileConfig> {
  @override
  final int typeId = 0;

  @override
  MobileConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MobileConfig(
      isInitialOpen: fields[0] as bool,
      selectedWorkspace: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MobileConfig obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isInitialOpen)
      ..writeByte(1)
      ..write(obj.selectedWorkspace);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MobileConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
