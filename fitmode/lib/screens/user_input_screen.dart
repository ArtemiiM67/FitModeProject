import 'package:flutter/material.dart';
import '../models/user.dart';
import '../theme.dart';

class UserInputScreen extends StatefulWidget {
  final Function(User) onComplete;
  const UserInputScreen({super.key, required this.onComplete});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String sex = 'Male';
  String activityLevel = 'Sedentary';
  String goal = 'Maintain';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Welcome
                  Text(
                    "Welcome!",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentGold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Username
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.accentGold),
                      ),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter username" : null,
                  ),
                  const SizedBox(height: 15),

                  // Age
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: "Age",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.accentGold),
                      ),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter age" : null,
                  ),
                  const SizedBox(height: 15),

                  // Weight
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: "Weight (kg)",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.accentGold),
                      ),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter weight" : null,
                  ),
                  const SizedBox(height: 15),

                  // Sex Dropdown
                  DropdownButtonFormField<String>(
                    value: sex,
                    decoration: InputDecoration(
                      labelText: "Sex",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.accentGold),
                      ),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    items: ['Male', 'Female', 'Other']
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => sex = val);
                    },
                  ),
                  const SizedBox(height: 15),

                  // Activity Level Dropdown
                  DropdownButtonFormField<String>(
                    value: activityLevel,
                    decoration: InputDecoration(
                      labelText: "Activity Level",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.accentGold),
                      ),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    items: ['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active']
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => activityLevel = val);
                    },
                  ),
                  const SizedBox(height: 15),

                  // Goal Dropdown
                  DropdownButtonFormField<String>(
                    value: goal,
                    decoration: InputDecoration(
                      labelText: "Goal",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppTheme.accentGold),
                      ),
                    ),
                    style: const TextStyle(color: AppTheme.textPrimary),
                    items: ['Maintain', 'Bulk', 'Cut']
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => goal = val);
                    },
                  ),
                  const SizedBox(height: 25),

                  // Continue Button
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          User user = User(
                            username: _usernameController.text,
                            age: int.parse(_ageController.text),
                            weight: double.parse(_weightController.text),
                            sex: sex,
                            activityLevel: activityLevel,
                            goal: goal,
                          );
                          widget.onComplete(user);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
