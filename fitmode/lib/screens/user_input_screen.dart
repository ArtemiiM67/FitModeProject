import 'package:flutter/material.dart';
import '../models/user.dart';
import 'home_screen.dart';
import '../theme.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({super.key});

  @override
  State<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  String sex = "Male";
  String activityLevel = "Moderate";
  String goal = "Maintain";

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        username: usernameController.text,
        age: int.parse(ageController.text),
        weight: double.parse(weightController.text),
        sex: sex,
        activityLevel: activityLevel,
        goal: goal,
      );

      // Navigate to HomeScreen with calculated macros
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Enter Your Info",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                    ),
                    validator: (val) => val!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: "Age",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: weightController,
                    decoration: const InputDecoration(
                      labelText: "Weight (kg)",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: sex,
                    items: ["Male", "Female"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setState(() => sex = val!),
                    decoration: const InputDecoration(
                      labelText: "Sex",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: activityLevel,
                    items: ["Low", "Moderate", "High"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setState(() => activityLevel = val!),
                    decoration: const InputDecoration(
                      labelText: "Activity Level",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: goal,
                    items: ["Bulk", "Cut", "Maintain"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setState(() => goal = val!),
                    decoration: const InputDecoration(
                      labelText: "Goal",
                      filled: true,
                      fillColor: AppTheme.cardBg,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text(
                        "Submit",
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
