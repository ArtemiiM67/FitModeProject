import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // controllers for text inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchesController = TextEditingController();

  String _selectedGender = 'Male';
  int _workoutsPerWeek = 3;
  String _selectedGoal = 'Maintain';

  int _currentStep = 0; // 0 = profile page, 1 = goal page

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    super.dispose();
  }

  // ---------- HELPERS ----------

  InputDecoration _inputDecoration({
    required String label,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null
          ? Icon(icon, color: AppTheme.accentGoldDim, size: 18)
          : null,
      filled: true,
      fillColor: AppTheme.cardBg,
      labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.accentGoldDim, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.accentGold, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 16),
      child: Text(
        text,
        style: GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  // ---------- PAGE 1: PROFILE ----------

  Widget _buildProfileStep(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Profile Setup',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.accentGold,
                  ),
                ),
                const SizedBox(height: 24),

                // Your Name
                _sectionTitle('Your name'),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: _inputDecoration(
                    label: 'Your name',
                    icon: Icons.person,
                  ),
                  validator: (val) =>
                      (val == null || val.trim().isEmpty) ? 'Required' : null,
                ),

                // Gender
                _sectionTitle('Gender'),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: _inputDecoration(
                    label: 'Gender',
                    icon: Icons.male,
                  ),
                  dropdownColor: AppTheme.cardBg,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  iconEnabledColor: AppTheme.accentGold,
                  items: const [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text('Female'),
                    ),
                    DropdownMenuItem(
                      value: 'Other',
                      child: Text('Other'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => _selectedGender = val);
                  },
                ),

                // Age
                _sectionTitle('Age'),
                TextFormField(
                  controller: _ageController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: _inputDecoration(
                    label: 'Age',
                    icon: Icons.cake_outlined,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    final v = int.tryParse(val ?? '');
                    if (v == null || v <= 0) return 'Enter a valid age';
                    return null;
                  },
                ),

                // Weight
                _sectionTitle('Weight'),
                TextFormField(
                  controller: _weightController,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  decoration: _inputDecoration(
                    label: 'Weight (lbs)',
                    icon: Icons.fitness_center,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    final v = double.tryParse(val ?? '');
                    if (v == null || v <= 0) return 'Enter a valid weight';
                    return null;
                  },
                ),

                // Height
                _sectionTitle('Height'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _feetController,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: _inputDecoration(
                          label: 'Feet',
                          icon: Icons.height,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          final v = int.tryParse(val ?? '');
                          if (v == null || v <= 0) return 'Feet';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _inchesController,
                        style: const TextStyle(color: AppTheme.textPrimary),
                        decoration: _inputDecoration(
                          label: 'Inches',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          final v = int.tryParse(val ?? '');
                          if (v == null || v < 0 || v > 11) return '0–11';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                // Workouts per week
                _sectionTitle('Workouts per week'),
                DropdownButtonFormField<int>(
                  value: _workoutsPerWeek,
                  decoration: _inputDecoration(
                    label: 'Workouts per week',
                    icon: Icons.fitness_center_outlined,
                  ),
                  dropdownColor: AppTheme.cardBg,
                  style: const TextStyle(color: AppTheme.textPrimary),
                  iconEnabledColor: AppTheme.accentGold,
                  items: List.generate(
                    7,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text('${i + 1}'),
                    ),
                  ),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => _workoutsPerWeek = val);
                  },
                ),

                const SizedBox(height: 28),

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handleNextPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentGold,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: GoogleFonts.nunito(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNextPressed() {
    if (_currentStep == 0) {
      // validate profile first
      if (_formKey.currentState?.validate() ?? false) {
        setState(() {
          _currentStep = 1;
        });
      }
    } else {
      _finishFlow();
    }
  }

  // ---------- PAGE 2: GOAL ----------

  Widget _goalCard({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final bool selected = _selectedGoal == value;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedGoal = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accentGold : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.accentGold : AppTheme.accentGoldDim,
            width: selected ? 1.6 : 1.0,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppTheme.accentGold.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selected ? Colors.black : Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? AppTheme.accentGold : AppTheme.accentGoldDim,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.black : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalStep(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "What's your goal to reach with us?",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 24),

              _goalCard(
                label: 'Cut',
                icon: Icons.trending_down,
                value: 'Cut',
              ),
              const SizedBox(height: 16),

              _goalCard(
                label: 'Maintain',
                icon: Icons.horizontal_rule,
                value: 'Maintain',
              ),
              const SizedBox(height: 16),

              _goalCard(
                label: 'Bulk',
                icon: Icons.trending_up,
                value: 'Bulk',
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _currentStep = 0;
                        });
                      },
                      child: Text(
                        'Back',
                        style: GoogleFonts.nunito(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _finishFlow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentGold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Continue',
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _finishFlow() {
    final user = User(
      username: _nameController.text.trim(),
      gender: _selectedGender,
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      weightLbs: double.tryParse(_weightController.text.trim()) ?? 0,
      heightFeet: int.tryParse(_feetController.text.trim()) ?? 0,
      heightInches: int.tryParse(_inchesController.text.trim()) ?? 0,
      workoutsPerWeek: _workoutsPerWeek,
      goal: _selectedGoal,
    );

    widget.onComplete(user);
  }

  // ---------- ROOT BUILD ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      body: _currentStep == 0
          ? _buildProfileStep(context)
          : _buildGoalStep(context),
    );
  }
}
