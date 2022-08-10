// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextContent _$TextContentFromJson(Map<String, dynamic> json) => TextContent(
      json['id'] as String,
      DateTime.parse(json['created_at'] as String),
      DateTime.parse(json['updated_at'] as String),
      json['original_text'] as String,
      json['original_language_id'] as String,
    );

Map<String, dynamic> _$TextContentToJson(TextContent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'original_text': instance.originalText,
      'original_language_id': instance.originalLanguageId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
