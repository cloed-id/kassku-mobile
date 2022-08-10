import 'package:flutter/material.dart';

import 'package:kassku_mobile/gen/assets.gen.dart';
import 'package:kassku_mobile/gen/colors.gen.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.logoKassku.image(width: 100),
            const SizedBox(height: 20),
            const Text(
              'Kassku | Cloed Indonesia',
              style: TextStyle(
                fontSize: 14,
                color: ColorName.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorName.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
