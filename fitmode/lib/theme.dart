import 'package:flutter/material.dart';

class AppTheme {
  // keep all your colors
  static const bgColor = Color(0xFF0A0A0A);
  static const cardBg = Color(0xFF161616);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFAAAAAA);
  static const accentGold = Color(0xFFF4D437);
  static const accentGoldDim = Color(0xFFFAA82C);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColor,
    primaryColor: accentGold,

    // kill ripple / highlight everywhere
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGold,
        foregroundColor: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: textPrimary,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        color: textPrimary,
      ),
    ),
  );
}
