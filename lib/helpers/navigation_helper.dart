import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kassku_mobile/helpers/user_helper.dart';
import 'package:kassku_mobile/modules/login/view/login_page.dart';
import 'package:kassku_mobile/modules/main/view/main_page.dart';
import 'package:kassku_mobile/modules/splash/view/splash_page.dart';
import 'package:kassku_mobile/modules/tutorial/view/tutorial_page.dart';

class NavigationHelper {
  final GoRouter goRouter = GoRouter(
    urlPathStrategy: UrlPathStrategy.path,
    observers: [],
    errorBuilder: (error, stackTrace) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              child: const Text('Keluar'),
              onPressed: () {
                GetIt.I<UserHelper>().logout();
              },
            ),
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splashpage',
        builder: (context, routerState) => const SplashPage(),
        redirect: redirectWhenAuthenticate,
      ),
      GoRoute(
        path: '/login',
        name: 'loginpage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
        redirect: (routerState) {
          final loggedIn = GetIt.I<UserHelper>().isLoggedIn;

          if (!loggedIn) return null;

          return '/';
        },
      ),
      GoRoute(
        path: '/main',
        name: 'mainpage',
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MainPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
        redirect: redirectWhenUnauthenticate,
      ),
      GoRoute(
        path: '/main/tutorial',
        name: 'tutorialpage',
        builder: (context, state) => const TutorialPage(),
        redirect: redirectWhenUnauthenticate,
      ),
    ],
  );

  static String redirectWhenAuthenticate(GoRouterState _) {
    final loggedIn = GetIt.I<UserHelper>().isLoggedIn;

    if (!loggedIn) return '/login';

    return '/main';
  }

  static String? redirectWhenUnauthenticate(GoRouterState _) {
    final loggedIn = GetIt.I<UserHelper>().isLoggedIn;

    if (!loggedIn) return '/login';

    return null;
  }

  void pop() {
    goRouter.pop();
  }

  void go(String location, {Object? extra}) {
    goRouter.go(location, extra: extra);
  }

  void goNamed(String name, {Object? extra}) {
    goRouter.goNamed(name, extra: extra);
  }

  void pushNamed(String name) {
    goRouter.pushNamed(name);
  }

  void goToSplash() {
    goNamed('splashpage');
  }

  void goToLogin() {
    goRouter.replaceNamed('loginpage');
  }

  void goToTransactions() {
    goRouter.replaceNamed('mainpage');
  }

  void pushToTutorial() {
    goRouter.pushNamed('tutorialpage');
  }
}
