import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable(createToJson: false)

/// Meta data for a response from API.
/// For example response of any list
class Meta {
  /// Called on any repository that required meta data
  Meta(
    this.currentPage,
    this.perPages,
    this.lastPage,
    this.total,
  );

  /// Converter from response map data to model
  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  // /// Converter from model to map data for request
  // Map<String, dynamic> toJson() => _$MetaToJson(this);

  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'per_page')
  final int perPages;

  @JsonKey(name: 'last_page')
  final int lastPage;

  final int total;
}
