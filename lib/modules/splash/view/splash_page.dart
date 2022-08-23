import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            Text(
              'KaSSku',
              style: TextStyle(
                color: ColorName.primary,
                fontWeight: FontWeight.bold,
                fontSize: 45,
                fontFamily: GoogleFonts.oswald().fontFamily,
                letterSpacing: 5,
              ),
            ),
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
