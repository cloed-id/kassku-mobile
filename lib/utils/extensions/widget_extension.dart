import 'package:flutter/material.dart';
import 'package:kassku_mobile/utils/screen_size.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

extension WidgetExtension on Widget {
  Widget widthFieldSupportMobile(BuildContext context) {
    return SizedBox(
      width: ScreenSize.isBelowExtraLargeScreen(context)
          ? double.infinity
          : MediaQuery.of(context).size.width * 0.3,
      child: this,
    );
  }

  Future<T?> showCustomDialog<T>(BuildContext context) {
    return showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: this,
      ),
    );
  }

  /// [percentHeight] must be between 0.0 and 1.0
  Future<T?> showSheet<T>(BuildContext context, {double percentHeight = 0.75}) {
    assert(
      percentHeight >= 0.0 && percentHeight <= 1.0,
      '[percentHeight] must be between 0.0 and 1.0',
    );

    final curHeight = MediaQuery.of(context).size.height * percentHeight;

    return showCustomModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (BuildContext context) {
        return this;
      },
      bounce: true,
      containerWidget: (context, animation, child) {
        return Material(
          color: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  height: curHeight,
                  child: child,
                ),
              ),
              Positioned(
                bottom: curHeight + 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 50,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
