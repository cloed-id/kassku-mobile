import 'package:json_annotation/json_annotation.dart';

part 'text_content.g.dart';

@JsonSerializable(explicitToJson: true)
class TextContent {
  TextContent(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.originalText,
    this.originalLanguageId,
  );

  factory TextContent.fromJson(Map<String, dynamic> json) =>
      _$TextContentFromJson(json);

  Map<String, dynamic> toJson() => _$TextContentToJson(this);

  final String id;

  @JsonKey(name: 'original_text')
  final String originalText;

  @JsonKey(name: 'original_language_id')
  final String originalLanguageId;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
}
