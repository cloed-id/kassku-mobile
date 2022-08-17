import 'package:hive_flutter/hive_flutter.dart';

part 'mobile_config.g.dart';

@HiveType(typeId: 0)
class MobileConfig extends HiveObject {
  MobileConfig({
    required this.isInitialOpen,
    required this.selectedWorkspace,
  });

  @HiveField(0)
  final bool isInitialOpen;

  @HiveField(1)
  final String? selectedWorkspace;

  MobileConfig copyWith({
    bool? isInitialOpen,
    String? selectedWorkspace,
  }) {
    return MobileConfig(
      isInitialOpen: isInitialOpen ?? this.isInitialOpen,
      selectedWorkspace: selectedWorkspace ?? this.selectedWorkspace,
    );
  }
}
