import 'package:flutter/material.dart';

import 'screens/get_started_screen.dart';
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
  bool _startedOnboarding = false;

  void _onUserComplete(User user) {
    setState(() {
      _user = user;
    });
  }

  void _startOnboarding() {
    setState(() {
      _startedOnboarding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitMode',
      theme: ThemeData.dark().copyWith(
        primaryColor: AppTheme.accentGold,
        scaffoldBackgroundColor: AppTheme.bgColor,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.accentGold, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade800, width: 1),
            borderRadius: BorderRadius.circular(10),
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

      home: _user != null
          ? HomeScreen(user: _user!)
          : _startedOnboarding
              ? UserInputScreen(onComplete: _onUserComplete)
              : GetStartedScreen(
                  onGetStarted: _startOnboarding,
                  onSignIn: () {
                    // TODO: push LoginScreen later
                  },
                ),
    );
  }
}
