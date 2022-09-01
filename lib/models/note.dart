import 'package:json_annotation/json_annotation.dart';
import 'package:kassku_mobile/models/text_content.dart';
import 'package:kassku_mobile/models/user.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note {
  Note(
    this.id,
    this.textContent,
    this.createdAt,
    this.updatedAt,
    this.memberWorkspaceId,
    this.createdBy,
  );

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  final String id;

  @JsonKey(name: 'member_workspace_id')
  final String memberWorkspaceId;

  @JsonKey(name: 'created_by')
  final User createdBy;

  @JsonKey(name: 'content')
  final TextContent textContent;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
}
