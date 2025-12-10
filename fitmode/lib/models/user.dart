import 'package:flutter/foundation.dart';

class User {
  final String username;
  final String gender;
  final int age;
  final double weightLbs;
  final int heightFeet;
  final int heightInches;
  final int workoutsPerWeek;
  final String goal; // Cut / Maintain / Bulk

  const User({
    required this.username,
    required this.gender,
    required this.age,
    required this.weightLbs,
    required this.heightFeet,
    required this.heightInches,
    required this.workoutsPerWeek,
    required this.goal,
  });

  @override
  String toString() {
    return 'User(username: $username, gender: $gender, age: $age, '
        'weightLbs: $weightLbs, height: ${heightFeet}\'$heightInches", '
        'workoutsPerWeek: $workoutsPerWeek, goal: $goal)';
  }
}
