import 'package:flutter/material.dart';

class AppColors {
  static const inkNavy = Color(0xFF101A2E);
  static const ledgerCream = Color(0xFFF7F3EA);
  static const emeraldPulse = Color(0xFF1FA97F);
  static const signalCoral = Color(0xFFE85C4A);
  static const goldStamp = Color(0xFFD9A441);
  static const slateGrey = Color(0xFF5B6472);

  static const saldoCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF101A2E),
      Color(0xFF1B3A4B),
      Color(0xFF1FA97F),
    ],
    stops: [0.0, 0.6, 1.0],
  );
}

class AppTypography {
  static const _fraunces = 'Fraunces';
  static const _plusJakarta = 'PlusJakartaSans';
  static const _ibmPlexMono = 'IBMPlexMono';

  static const displayLarge = TextStyle(
    fontFamily: _fraunces,
    fontSize: 40,
    fontWeight: FontWeight.w700,
  );

  static const displayMedium = TextStyle(
    fontFamily: _fraunces,
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _plusJakarta,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const bodySmall = TextStyle(
    fontFamily: _plusJakarta,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  static const monoData = TextStyle(
    fontFamily: _ibmPlexMono,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.ledgerCream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.emeraldPulse,
      surface: AppColors.ledgerCream,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.inkNavy,
      foregroundColor: Colors.white,
    ),
    fontFamily: 'PlusJakartaSans',
  );
}
