import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  runApp(FitModeApp());
}

class FitModeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMode',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Using your custom theme
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Start in luxury black theme
      home: HomeScreen(),
    );
  }
}
