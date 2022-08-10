import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';
import 'package:kassku_mobile/helpers/navigation_helper.dart';

class FlashMessageHelper {
  /// [message] nullable because we need to create stub in the tests
  /// to fit with the argMatcher
  /// https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md
  void showError(
    String? message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    showTopFlash(message ?? ' - ', isError: true);
  }

  void showTopFlash(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 5),
  }) {
    final context = GetIt.I<NavigationHelper>().goRouter.navigator!.context;

    showFlash<void>(
      context: context,
      duration: duration,
      builder: (_, controller) {
        return Flash<void>(
          controller: controller,
          borderRadius: const BorderRadius.all(Radius.circular(21)),
          boxShadows: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          backgroundColor:
              isError ? ColorName.errorBackground : ColorName.success,
          child: FlashBar(
            icon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: isError
                  ? const Icon(
                      Icons.error,
                      color: ColorName.errorForeground,
                      size: 35,
                    )
                  : const Icon(
                      Icons.check_circle,
                      color: ColorName.successVariant,
                      size: 35,
                    ),
            ),
            content: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: isError
                    ? ColorName.errorForeground
                    : ColorName.successVariant,
              ),
            ),
          ),
        );
      },
    );
  }
}
