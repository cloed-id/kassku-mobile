import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kassku_mobile/app/app.dart';
import 'package:kassku_mobile/app/app_bloc_observer.dart';
import 'package:kassku_mobile/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  BlocOverrides.runZoned(
    () => runApp(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('id')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const App(),
      ),
    ),
    blocObserver: AppBlocObserver(),
  );
}
