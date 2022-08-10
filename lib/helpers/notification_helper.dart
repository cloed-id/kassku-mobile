import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.high,
);

/// Handle all notification service
class NotificationHelper {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late NotificationDetails _platformChannelSpecifics;

  /// Initialize notification service
  Future<void> initialize() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _selectNotification,
    );

    await _requestPermissionNotification();

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'user_id_1',
      'user',
      channelDescription: 'Users application',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    _platformChannelSpecifics =
        const NotificationDetails(android: androidPlatformChannelSpecifics);

    // final messaging = FirebaseMessaging.instance;
    // await messaging.requestPermission();
    // await messaging.setForegroundNotificationPresentationOptions(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // await _setupFCM();
  }

  /// Manually show notification
  Future<void> show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin
        .show(id, title, body, _platformChannelSpecifics, payload: payload);
  }

  Future<void> _requestPermissionNotification() async {
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(androidChannel);
    } else if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> _selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await GetIt.I<NavigationHelper>().push<void>(const MainRoute());
  }

  // Future<void> _setupFCM() async {
  //   FirebaseMessaging.onBackgroundMessage(_myBackgroundMessageHandler);
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     final notification = message.notification;
  //     final android = message.notification?.android;

  //     if (notification != null && android != null) {
  //       GetIt.I<FlutterLocalNotificationsPlugin>().show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             androidChannel.id,
  //             androidChannel.name,
  //             channelDescription: androidChannel.description,
  //           ),
  //         ),
  //       );
  //     }
  //   });

  //   FirebaseMessaging.instance.onTokenRefresh
  //       .listen((fcmToken) {})
  //       .onError((dynamic err) {});
  // }

  // static Future<dynamic> _myBackgroundMessageHandler(
  //   RemoteMessage message,
  // ) async {
  //   // await Firebase.initializeApp();

  //   // if (message.containsKey('data')) {
  //   //   // Handle data message
  //   //   final dynamic data = message['data'];
  //   // }

  //   // if (message.containsKey('notification')) {
  //   //   // Handle notification message
  //   //   final dynamic notification = message['notification'];
  //   // }
  // }

  static Future<void> _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    // await showDialog<void>(
    //   context: GetIt.I<AppRouter>().navigatorKey.currentContext!,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title ?? 'Notification'),
    //     content: Text(body ?? ''),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    // ignore: lines_longer_than_80_chars
    //           await GetIt.I<NavigationHelper>().push<void>(const MainRoute());
    //         },
    //         child: const Text('Ok'),
    //       )
    //     ],
    //   ),
    // );
  }
}
