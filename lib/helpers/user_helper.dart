import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/flash_message_helper.dart';
import 'package:kassku_mobile/helpers/navigation_helper.dart';
import 'package:kassku_mobile/models/user.dart';
import 'package:kassku_mobile/services/hive_service.dart';

/// Service to manage the user so that it can be used in any class.
class UserHelper {
  String lang = 'id';

  // Is user logged in?
  bool get isLoggedIn => GetIt.I<HiveService>().getUser() != null;

  User? getUser() {
    return GetIt.I<HiveService>().getUser();
  }

  /// Handle logout
  Future<void> logout() async {
    try {
      await GetIt.I<HiveService>().deleteUser();
      await GetIt.I<FlutterSecureStorage>().deleteAll();
      GetIt.I<HiveService>().resetMobileConfig();
      GetIt.I<NavigationHelper>().goToLogin();
    } catch (e) {
      GetIt.I<FlashMessageHelper>().showError(e.toString());
    }
  }
}
