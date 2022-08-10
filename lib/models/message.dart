import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(explicitToJson: true)
class Message {
  Message(this.dev, this.prod);

  /// Converter from response map data to model
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  // /// Converter from model to map data for request
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  final String dev;
  final String prod;
}
