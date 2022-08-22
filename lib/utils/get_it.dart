import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/helpers/navigation_helper.dart';
import 'package:kassku_mobile/helpers/one_signal_helper.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/services/hive_service.dart';
import 'package:kassku_mobile/utils/constants.dart';

/// Container for DI
class GetItContainer {
  /// Initialize the DI Contanier in MainApp
  static void initialize() {
    GetIt.I.registerLazySingleton<OneSignalHelper>(
      () => OneSignalHelper(kOneSignalAppId),
    );

    GetIt.I.registerSingleton<StreamController<String>>(
      StreamController<String>.broadcast(),
      instanceName: 'broadcast_notification_event',
    );

    GetIt.I.registerSingleton<HiveService>(HiveService(Hive));
    GetIt.I.registerSingleton<UserHelper>(UserHelper());

    GetIt.I.registerSingleton<NavigationHelper>(
      NavigationHelper(),
    );
    GetIt.I.registerSingleton<FlashMessageHelper>(FlashMessageHelper());

    GetIt.I
        .registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  }

  /// Initialize the DI Container in SplashScreen
  static void initializeConfig(Dio dio) {
    GetIt.I.registerSingleton<Dio>(dio);
  }
}
