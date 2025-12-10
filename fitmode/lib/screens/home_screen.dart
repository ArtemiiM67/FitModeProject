import 'package:flutter/material.dart';
import '../models/user.dart';
import '../theme.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Map<String, double> remainingMacros;
  String dailyQuote = "";

  final List<String> quotes = [
    "Push yourself because no one else will.",
    "Strive for progress, not perfection.",
    "Your body can stand almost anything. It’s your mind you have to convince.",
    "Small steps every day.",
    "Strong is the new beautiful."
  ];

  @override
  void initState() {
    super.initState();
    remainingMacros = calculateDailyMacros(widget.user);
    dailyQuote = quotes[Random().nextInt(quotes.length)];
  }

  Map<String, double> calculateDailyMacros(User user) {
    double calories = user.weight * 30;
    if (user.goal == "Bulk") calories += 500;
    if (user.goal == "Cut") calories -= 500;
    double protein = user.weight * 2;
    double fat = calories * 0.25 / 9;
    double carbs = (calories - (protein * 4 + fat * 9)) / 4;

    return {
      "Calories": calories,
      "Protein": protein,
      "Fat": fat,
      "Carbs": carbs,
    };
  }

  void _showAddMealDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String mealName = '';
    double cals = 0, protein = 0, fat = 0, carbs = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBg,
        title: const Text("Add Meal", style: TextStyle(color: AppTheme.textPrimary)),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Meal Name",
                    filled: true,
                    fillColor: AppTheme.bgColor,
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: AppTheme.textPrimary),
                  onSaved: (val) => mealName = val ?? '',
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Calories",
                    filled: true,
                    fillColor: AppTheme.bgColor,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => cals = double.tryParse(val ?? '0') ?? 0,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Protein (g)",
                    filled: true,
                    fillColor: AppTheme.bgColor,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => protein = double.tryParse(val ?? '0') ?? 0,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Fat (g)",
                    filled: true,
                    fillColor: AppTheme.bgColor,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => fat = double.tryParse(val ?? '0') ?? 0,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Carbs (g)",
                    filled: true,
                    fillColor: AppTheme.bgColor,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => carbs = double.tryParse(val ?? '0') ?? 0,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              _formKey.currentState!.save();
              setState(() {
                remainingMacros["Calories"] = (remainingMacros["Calories"]! - cals).clamp(0, double.infinity);
                remainingMacros["Protein"] = (remainingMacros["Protein"]! - protein).clamp(0, double.infinity);
                remainingMacros["Fat"] = (remainingMacros["Fat"]! - fat).clamp(0, double.infinity);
                remainingMacros["Carbs"] = (remainingMacros["Carbs"]! - carbs).clamp(0, double.infinity);
              });
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
      print("Tapped nav index $index");
    });
  }

  Widget _buildMacroCard(String label, double value) {
    return Container(
      width: 150,
      height: 80,
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentGoldDim),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            const SizedBox(height: 4),
            Text(value.round().toString(),
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Daily Quote
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentGoldDim),
                ),
                child: Text(
                  "\"$dailyQuote\"",
                  style: const TextStyle(
                      color: AppTheme.accentGold, fontStyle: FontStyle.italic, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 15),

              // Welcome
              Text(
                "Welcome, ${widget.user.username}!",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentGold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),


              // Macros centered grid (2×2)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMacroCard("Calories", remainingMacros["Calories"]!),
                      const SizedBox(width: 12),
                      _buildMacroCard("Protein", remainingMacros["Protein"]!),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMacroCard("Fat", remainingMacros["Fat"]!),
                      const SizedBox(width: 12),
                      _buildMacroCard("Carbs", remainingMacros["Carbs"]!),
                    ],
                  ),
                ],
              ),


              const SizedBox(height: 15),

              // Add Meal Button
              SizedBox(
                width: 180,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => _showAddMealDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGold,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text("Add Meal",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        backgroundColor: AppTheme.cardBg,
        selectedItemColor: AppTheme.accentGold,
        unselectedItemColor: AppTheme.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.scale), label: "Scale"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Social"),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Workout"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
