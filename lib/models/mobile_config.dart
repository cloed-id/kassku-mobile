import 'package:hive_flutter/hive_flutter.dart';

part 'mobile_config.g.dart';

@HiveType(typeId: 0)
class MobileConfig extends HiveObject {
  MobileConfig({
    required this.isInitialOpen,
  });

  @HiveField(0)
  final bool isInitialOpen;
}
