import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgColor = Color(0xFF0A0A0A);
  static const Color cardBg = Color(0xFF161616);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA0A0A0);
  static const Color accentGold = Color(0xFFD4AF37);
  static const Color accentGoldDim = Color(0xFFAA8C2C);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColor,
    colorScheme: ColorScheme.dark(
      primary: accentGold,
      secondary: accentGold,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentGold,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData.light();
}
