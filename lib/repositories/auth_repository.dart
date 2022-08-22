import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/helpers/one_signal_helper.dart';
import 'package:kassku_mobile/models/base_response.dart';
import 'package:kassku_mobile/models/user.dart';
import 'package:kassku_mobile/repositories/base_repository.dart';
import 'package:kassku_mobile/services/hive_service.dart';
import 'package:kassku_mobile/utils/constants.dart';
import 'package:kassku_mobile/utils/enums.dart';
import 'package:kassku_mobile/utils/exceptions.dart';
import 'package:kassku_mobile/utils/typedefs.dart';

class AuthRepository extends BaseRepository {
  Future<BaseResponse<User>> submitLogin(
    String username,
    String password,
  ) async {
    final response = await post(
      ApiEndPoint.kApiLogin,
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.status == ResponseStatus.success) {
      final data = response.data! as MapString;
      final rawData = data['data'] as MapString;
      final token = data['token'] as String;

      final user = User.fromJson(rawData);
      GetIt.I<HiveService>().storeUser(user);

      await GetIt.I<OneSignalHelper>().setExternalId(user.id);

      final storage = GetIt.I<FlutterSecureStorage>();

      await storage.write(key: kAccessToken, value: token);

      return BaseResponse.success(user);
    }
    throw CustomExceptionString(response.message ?? 'Unknown error');
  }

  Future<BaseResponse<User>> submitRegister(
    String username,
    String password,
  ) async {
    final response = await post(
      ApiEndPoint.kApiRegister,
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.status == ResponseStatus.success) {
      final data = response.data! as MapString;
      final rawData = data['data'] as MapString;
      final token = data['token'] as String;

      final user = User.fromJson(rawData);
      GetIt.I<HiveService>().storeUser(user);

      await GetIt.I<OneSignalHelper>().setExternalId(user.id);

      final storage = GetIt.I<FlutterSecureStorage>();

      await storage.write(key: kAccessToken, value: token);

      return BaseResponse.success(user);
    }
    throw CustomExceptionString(response.message ?? 'Unknown error');
  }
}
