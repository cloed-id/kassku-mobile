import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kassku_mobile/app/cubit/app_cubit.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/helpers/navigation_helper.dart';
import 'package:kassku_mobile/modules/splash/view/splash_page.dart';
import 'package:kassku_mobile/utils/get_it.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

///MainApp
class App extends StatefulWidget {
  ///Constructor for main flutter app
  const App({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final ColorScheme _colorSchemeLight = const ColorScheme(
    brightness: Brightness.light,
    primary: ColorName.primary,
    primaryContainer: ColorName.primaryContainer,
    secondary: ColorName.secondary,
    secondaryContainer: ColorName.secondaryContainer,
    background: Color.fromARGB(255, 228, 228, 228),
    error: ColorName.errorBackground,
    surface: ColorName.white,
    onPrimary: ColorName.white,
    onSecondary: ColorName.primary,
    onSurface: ColorName.textPrimary,
    onBackground: ColorName.textPrimary,
    onError: ColorName.errorForeground,
  );

  @override
  void initState() {
    HttpOverrides.global = MyHttpOverrides();

    GetItContainer.initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppCubit(context.locale.languageCode)..init(),
      child: _AppBody(colorScheme: _colorSchemeLight),
    );
  }
}

class _AppBody extends StatelessWidget {
  const _AppBody({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubit>().state;
    final theme = ThemeData(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      backgroundColor: colorScheme.background,
      textTheme: GoogleFonts.robotoTextTheme(
        const TextTheme(
          subtitle1: TextStyle(
            color: ColorName.textPrimary,
          ),
          subtitle2: TextStyle(
            color: ColorName.textSecondary,
          ),
          headline5: TextStyle(
            color: ColorName.textPrimary,
          ),
          headline6: TextStyle(
            color: ColorName.textPrimary,
          ),
          bodyText2: TextStyle(
            color: ColorName.textPrimary,
          ),
          bodyText1: TextStyle(
            color: ColorName.textSecondary,
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );

    if (state is AppLoading) {
      return MaterialApp(theme: theme, home: const SplashPage());
    }

    final appRouter = GetIt.I<NavigationHelper>().goRouter;

    return MaterialApp.router(
      title: 'Kassku | Cloed.ID',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      theme: theme,
    );
  }
}
