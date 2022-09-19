import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics_web/firebase_analytics_web.dart';

import 'package:flutter/foundation.dart';

class AnalyticsHelper {
  static Future<void> setUserId({
    String? id,
    AnalyticsCallOptions? callOptions,
  }) {
    if (kIsWeb) {
      return FirebaseAnalyticsWeb().setUserId(id: id, callOptions: callOptions);
    } else {
      return FirebaseAnalytics.instance
          .setUserId(id: id, callOptions: callOptions);
    }
  }

  static Future<void> logEvent({
    required String name,
    Map<String, Object?>? parameters,
  }) {
    if (kIsWeb) {
      return FirebaseAnalyticsWeb()
          .logEvent(name: name, parameters: parameters);
    } else {
      return FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    }
  }

  static Future<void> logLogin({
    String? loginMethod,
    AnalyticsCallOptions? callOptions,
  }) {
    if (kIsWeb) {
      return logEvent(
        name: 'login',
        parameters: {
          'login_method': loginMethod,
        },
      );
    } else {
      return FirebaseAnalytics.instance
          .logLogin(loginMethod: loginMethod, callOptions: callOptions);
    }
  }

  static Future<void> logSignUp({
    required String signUpMethod,
  }) {
    if (kIsWeb) {
      return logEvent(
        name: 'sign_up',
        parameters: {
          'sign_up_method': signUpMethod,
        },
      );
    } else {
      return FirebaseAnalytics.instance.logSignUp(
        signUpMethod: signUpMethod,
      );
    }
  }

  static Future<void> logTutorialBegin() {
    return logEvent(name: 'tutorial_begin');
  }

  static Future<void> logTutorialComplete() {
    return logEvent(name: 'tutorial_complete');
  }
}
