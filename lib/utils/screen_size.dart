import 'package:flutter/material.dart';

class ScreenSize {
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <= 540;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 480 &&
        MediaQuery.of(context).size.width <= 768;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 768;
  }

  static bool isExtraLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1024;
  }

  static bool isBelowLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <= 768;
  }

  static bool isBelowExtraLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width <= 1024;
  }
}
