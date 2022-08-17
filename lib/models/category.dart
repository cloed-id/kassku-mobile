import 'package:json_annotation/json_annotation.dart';
import 'package:kassku_mobile/models/text_content.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category {
  Category(
    this.id,
    this.textContent,
    this.createdAt,
    this.updatedAt,
    this.usedCount,
  );

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  final String id;

  @JsonKey(name: 'name_text_content')
  final TextContent textContent;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @JsonKey(ignore: true)
  bool isSelected = false;

  @JsonKey(name: 'used_count')
  final int usedCount;
}
