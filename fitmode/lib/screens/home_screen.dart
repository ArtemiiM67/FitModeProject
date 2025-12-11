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
  late Map<String, double> totalMacros;
  String dailyQuote = "";
  List<Map<String, dynamic>> recentMeals = [];

  final List<String> quotes = [
    "Push yourself because no one else will.",
    "Strive for progress, not perfection.",
    "Your body can stand almost anything. It’s your mind you have to convince.",
    "Small steps every day.",
    "Strong is the new beautiful."
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    totalMacros = calculateDailyMacros(widget.user);
    remainingMacros = Map<String, double>.from(totalMacros);
    dailyQuote = quotes[Random().nextInt(quotes.length)];
  }

  Map<String, double> calculateDailyMacros(User user) {
    double calories = user.weightLbs * 30;
    if (user.goal == "Bulk") calories += 500;
    if (user.goal == "Cut") calories -= 500;

    double protein = user.weightLbs * 2;
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
        title: const Text(
          "Add Meal",
          style: TextStyle(color: AppTheme.textPrimary),
        ),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _formKey.currentState!.save();
              setState(() {
                remainingMacros["Calories"] =
                    (remainingMacros["Calories"]! - cals).clamp(0, double.infinity);
                remainingMacros["Protein"] =
                    (remainingMacros["Protein"]! - protein).clamp(0, double.infinity);
                remainingMacros["Fat"] =
                    (remainingMacros["Fat"]! - fat).clamp(0, double.infinity);
                remainingMacros["Carbs"] =
                    (remainingMacros["Carbs"]! - carbs).clamp(0, double.infinity);

                // Add to recent meals
                recentMeals.insert(0, {
                  "name": mealName,
                  "Calories": cals,
                  "Protein": protein,
                  "Fat": fat,
                  "Carbs": carbs,
                });
                if (recentMeals.length > 5) recentMeals.removeLast();
              });
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildMacroCircle(String label, double remaining, double total, Color color) {
    double progress = remaining / total;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: AppTheme.cardBg.withOpacity(0.3),
                color: color,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  remaining.round().toString(),
                  style: const TextStyle(
                      color: AppTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11, letterSpacing: 1.1),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentGoldDim.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            meal["name"],
            style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
          ),
          Text(
            "${meal["Calories"].round()} cal",
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ],
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "FitMode",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentGold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.user.goal == "Bulk"
                              ? "Let’s pack on clean size."
                              : widget.user.goal == "Cut"
                                  ? "Dialed in. Time to lean out."
                                  : "Stay sharp. Stay consistent.",
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.cardBg,
                      child: Text(
                        widget.user.username.isNotEmpty
                            ? widget.user.username[0].toUpperCase()
                            : "?",
                        style: const TextStyle(
                          color: AppTheme.accentGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Quote card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppTheme.accentGoldDim.withOpacity(0.4)),
                  ),
                  child: Text(
                    "\"$dailyQuote\"",
                    style: const TextStyle(
                      color: AppTheme.accentGold,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Section title
                const Text(
                  "Today’s targets",
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                // Macro grid (2x2)
                Wrap(
                  spacing: 12, // horizontal spacing
                  runSpacing: 12, // vertical spacing
                  alignment: WrapAlignment.center,
                  children: [
                    _buildMacroCircle("Calories", remainingMacros["Calories"]!, totalMacros["Calories"]!, AppTheme.accentGold),
                    _buildMacroCircle("Protein", remainingMacros["Protein"]!, totalMacros["Protein"]!, Colors.green),
                    _buildMacroCircle("Fat", remainingMacros["Fat"]!, totalMacros["Fat"]!, Colors.orange),
                    _buildMacroCircle("Carbs", remainingMacros["Carbs"]!, totalMacros["Carbs"]!, Colors.blue),
                  ],
                ),


                const SizedBox(height: 24),

                // Add meal CTA
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _showAddMealDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      "Add Meal",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Recent Food Log
                const Text(
                  "Recent Food Log",
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (recentMeals.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.accentGoldDim.withOpacity(0.3)),
                    ),
                    child: const Center(
                      child: Text(
                        "No meals added yet",
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                  )
                else
                  Column(
                    children: recentMeals.map((meal) => _buildRecentMealCard(meal)).toList(),
                  ),

                const SizedBox(height: 12),

                // Small helper text
                const Text(
                  "Track every meal to keep your macros locked in.",
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
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
