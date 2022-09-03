import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/utils/constants.dart';
import 'package:kassku_mobile/utils/typedefs.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalHelper {
  OneSignalHelper(this._appId) {
    _initial();
  }

  final String _appId;

  void _initial() {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId(_appId);

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      Logger().i('User accepted notifications: $accepted');
    });

    OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
      Logger().d('In-App message displayed: $message');
    });

    // get data from income notification
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {
      Logger()
          .d('Notification displayed: ${event.notification.additionalData}');

      final data = event.notification.additionalData;

      if (data != null && data.containsKey('event_key')) {
        final eventKey = data['event_key'] as String;

        GetIt.I
            .get<StreamController<String>>(
              instanceName: 'broadcast_notification_event',
            )
            .sink
            .add(eventKey);
      }
    });
  }

  Future<MapString> setExternalId(String externalId) {
    return Future.value({});
    return OneSignal.shared.setExternalUserId(externalId);
  }

  Future<void> sendTag(String key, String value) {
    return Future.value();
    return OneSignal.shared.sendTag(key, value);
  }

  Future<void> sendNotification(
    String? externalId,
    String eventKey, {
    required String headingId,
    required String headingEn,
    required String contentId,
    required String contentEn,
  }) async {
    return;
    const api = 'https://onesignal.com/api/v1/notifications';
    final dio = GetIt.I<Dio>();

    try {
      await dio.post<MapString>(
        api,
        data: {
          'app_id': kOneSignalAppId,
          'channel_for_external_user_ids': 'push',
          'contents': {'id': contentId, 'en': contentEn},
          'headings': {'id': headingId, 'en': headingEn},
          'data': {'event_key': eventKey},
          if (externalId != null)
            'include_external_user_ids': [externalId]
          else
            'filters': [
              {
                'field': 'tag',
                'key': 'user_type',
                'relation': '=',
                'value': 'mitra'
              }
            ]
        },
        options: Options(
          headers: <String, dynamic>{
            'Content-Type': 'application/json',
            'Authorization': 'Basic $kRestApiKeyOneSignal',
          },
        ),
      );
    } catch (e, s) {
      Logger().e(e, s);
    }
  }
}
