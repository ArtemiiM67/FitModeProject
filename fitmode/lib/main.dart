import 'package:flutter/material.dart';
import 'screens/user_input_screen.dart';
import 'screens/home_screen.dart';
import 'models/user.dart';
import 'theme.dart';

void main() {
  runApp(const FitModeApp());
}

class FitModeApp extends StatefulWidget {
  const FitModeApp({super.key});

  @override
  State<FitModeApp> createState() => _FitModeAppState();
}

class _FitModeAppState extends State<FitModeApp> {
  User? _user;

  void _onUserComplete(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMode',
      theme: ThemeData.dark().copyWith(
        primaryColor: AppTheme.accentGold,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.accentGold, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade800, width: 1),
          ),
          labelStyle: TextStyle(color: AppTheme.textSecondary),
          hintStyle: TextStyle(color: AppTheme.textSecondary),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppTheme.accentGold,
          selectionColor: AppTheme.accentGold.withOpacity(0.3),
          selectionHandleColor: AppTheme.accentGold,
        ),
      ),
      home: _user == null
        ? UserInputScreen(onComplete: _onUserComplete)
        : HomeScreen(user: _user!),
    );
  }
}
