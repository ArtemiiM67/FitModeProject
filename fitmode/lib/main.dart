import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/user_input_screen.dart';
import 'screens/home_screen.dart';
import 'models/user.dart';

void main() {
  runApp(const FitModeApp());
}

class FitModeApp extends StatelessWidget {
  const FitModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMode',
      theme: AppTheme.lightTheme,
      home: const UserInputScreen(), // Start with user info screen
    );
  }
}
