import 'package:flutter/material.dart';

class AppTheme {
  static const bgColor = Color(0xFF0A0A0A);
  static const cardBg = Color(0xFF161616);
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFA0A0A0);
  static const accentGold = Color(0xFFD4AF37);
  static const accentGoldDim = Color(0xFFAA8C2C);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColor,
    primaryColor: accentGold,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGold,
        foregroundColor: Colors.black,
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: textPrimary),
    ),
  );
}
