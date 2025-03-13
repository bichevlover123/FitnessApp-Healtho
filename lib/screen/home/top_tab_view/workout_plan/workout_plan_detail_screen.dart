import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healtho_gym/common/color_extension.dart';

class CalorieCalculator {
  static Future<Map<String, dynamic>> calculateCalories(String planGoal) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) throw Exception('User data not found');

      dynamic weightValue = (userDoc.data() as Map<String, dynamic>)['weight'];
      double weight = 0.0;

      if (weightValue is String) {
        String numericPart = weightValue.replaceAll(RegExp(r'[^0-9.]'), '');
        weight = double.tryParse(numericPart) ?? 0.0;
      } else if (weightValue != null) {
        weight = weightValue.toDouble();
      }

      if (weight <= 0) throw Exception('Invalid weight data');

      double maintenance = weight * 30;
      double target = maintenance;

      switch (planGoal.toLowerCase()) {
        case 'muscle_gain':
          target = maintenance + 1000;
          break;
        case 'fat_loss':
        case 'weight_loss':
          target = maintenance - 500;
          break;
      }

      return {
        'maintenance': maintenance,
        'target': target,
        'goal': planGoal,
      };
    } catch (e) {
      throw Exception('Calorie calculation failed: ${e.toString()}');
    }
  }
}

class WorkoutPlanDetailScreen extends StatelessWidget {
  final Map<String, dynamic> plan;

  const WorkoutPlanDetailScreen({super.key, required this.plan});

  // Add this formatting method
  List<Widget> _getRoutine(String split) {
    switch (split) {
      case 'upper_lower_2x_week':
        return _buildUpperLowerRoutine();
      case 'fullbody_3x_week':
        return _buildFullbodyRoutine();
      case 'push_pull_legs_2x_week':
        return _buildPPL2xRoutine();
      case 'push_pull_legs_1x_week':
        return _buildPPL1xRoutine();
      default:
        return [];
    }
  }
  String _formatPlanGoal(String goal) {
    return goal.replaceAll('_', ' ').split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final String split = plan['split']?.toString() ?? '';
    final String planGoal = plan['goal']?.toString() ?? 'maintain';

    return Scaffold(
      appBar: AppBar(
        title: Text(plan['name']),
        backgroundColor: TColor.secondary,
      ),
      body: FutureBuilder(
        future: CalorieCalculator.calculateCalories(planGoal),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final calorieData = snapshot.data as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCalorieCard(calorieData),
                const SizedBox(height: 20),
                // Updated to use formatted goal
                _buildDetailCard('Workout Goal', _formatPlanGoal(planGoal)),
                _buildDetailCard('Duration', '${plan['duration']} weeks'),
                _buildDetailCard('Training Split', split),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Training Schedule',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: TColor.primaryText,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: _getRoutine(split),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalorieCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: TColor.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Nutrition Plan',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColor.primary)),
            const SizedBox(height: 10),
            _buildCalorieRow('Maintenance', data['maintenance']),
            // Updated to use formatted goal
            _buildCalorieRow('Target (${_formatPlanGoal(data['goal'])})', data['target']),
          ],
        ),
      ),
    );
  }


  Widget _buildCalorieRow(String label, double calories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 16)),
          Text('${calories.round()} kcal',
              style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }


  List<Widget> _buildPPL2xRoutine() {
    return [
      _buildExerciseDay("Day 1: Push Day", [
        "Bench Press - 2 sets to failure",
        "Overhead Press - 2 sets to failure",
        "Incline Dumbbell Press - 2 sets to failure",
        "Lateral Raises - 2 sets to failure",
        "Tricep Pushdowns - 2 sets to failure"
      ]),
      _buildExerciseDay("Day 2: Pull Day", [
        "Deadlifts - 2 sets to failure",
        "Pull-Ups - 2 sets to failure",
        "Barbell Rows - 2 sets to failure",
        "Face Pulls - 2 sets to failure",
        "Hammer Curls - 2 sets to failure"
      ]),
      _buildExerciseDay("Day 3: Legs Day", [
        "Squats - 2 sets to failure",
        "Leg Press - 2 sets to failure",
        "Romanian Deadlifts - 2 sets to failure",
        "Leg Curls - 2 sets to failure",
        "Calf Raises - 2 sets to failure"
      ]),
      _buildRestDay("Day 4: Active Recovery", [
        "Light cardio",
        "Mobility work",
        "Foam rolling"
      ]),
      _buildExerciseDay("Day 5: Push Day Repeat", [
        "Incline Bench Press - 2 sets to failure",
        "Dumbbell Shoulder Press - 2 sets to failure",
        "Chest Dips - 2 sets to failure",
        "Skull Crushers - 2 sets to failure"
      ]),
      _buildExerciseDay("Day 6: Pull Day Repeat", [
        "T-bar Rows - 2 sets to failure",
        "Lat Pulldowns - 2 sets to failure",
        "Cable Rows - 2 sets to failure",
        "Preacher Curls - 2 sets to failure"
      ]),
      _buildExerciseDay("Day 7: Legs Day Repeat", [
        "Front Squats - 2 sets to failure",
        "Bulgarian Split Squats - 2 sets to failure",
        "Leg Extensions - 2 sets to failure",
        "Seated Calf Raises - 2 sets to failure"
      ]),
    ];
  }

  List<Widget> _buildPPL1xRoutine() {
    return [
      _buildExerciseDay("Day 1: Push Day", [
        "Bench Press - 2 sets to failure",
        "Overhead Press - 2 sets to failure",
        "Incline Dumbbell Press - 2 sets to failure",
        "Tricep Dips - 2 sets to failure",
        "Lateral Raises - 2 sets to failure"
      ]),
      _buildRestDay("Day 2: Rest", [
        "Complete recovery",
        "Light stretching if needed"
      ]),
      _buildExerciseDay("Day 3: Pull Day", [
        "Deadlifts - 2 sets to failure",
        "Pull-Ups - 2 sets to failure",
        "Barbell Rows - 2 sets to failure",
        "Face Pulls - 2 sets to failure",
        "Barbell Curls - 2 sets to failure"
      ]),
      _buildRestDay("Day 4: Rest", [
        "Active recovery",
        "30-minute walk or yoga"
      ]),
      _buildExerciseDay("Day 5: Legs Day", [
        "Squats - 2 sets to failure",
        "Leg Press - 2 sets to failure",
        "Romanian Deadlifts - 2 sets to failure",
        "Leg Curls - 2 sets to failure",
        "Calf Raises - 2 sets to failure"
      ]),
      _buildRestDay("Day 6: Rest", [
        "Complete rest",
        "Focus on recovery"
      ]),
      _buildRestDay("Day 7: Rest", [
        "Full recovery day",
        "Prepare for next week"
      ]),
    ];
  }

  List<Widget> _buildUpperLowerRoutine() {
    return [
      _buildExerciseDay("Day 1: Upper Body", [
        "Bench Press - 2 sets to failure",
        "Overhead Press - 2 sets to failure",
        "Pull-Ups - 2 sets to failure",
        "Barbell Rows - 2 sets to failure",
        "Dumbbell Curls - 2 sets to failure"
      ]),
      _buildExerciseDay("Day 2: Lower Body", [
        "Squats - 2 sets to failure",
        "Deadlifts - 2 sets to failure",
        "Leg Press - 2 sets to failure",
        "Leg Curls - 2 sets to failure",
        "Calf Raises - 2 sets to failure"
      ]),
      _buildRestDay("Day 3: Active Recovery", [
        "Light stretching or yoga",
        "Foam rolling",
        "30-45 minute walk"
      ]),
      _buildExerciseDay("Day 4: Upper Body Repeat", [
        "Incline Bench Press - 2 sets to failure",
        "Lat Pulldowns - 2 sets to failure",
        "Dumbbell Shoulder Press - 2 sets to failure",
        "Cable Rows - 2 sets to failure"
      ]),
      _buildExerciseDay("Day 5: Lower Body Repeat", [
        "Front Squats - 2 sets to failure",
        "Romanian Deadlifts - 2 sets to failure",
        "Lunges - 2 sets to failure",
        "Leg Extensions - 2 sets to failure"
      ]),
      _buildRestDay("Day 6: Light Cardio", [
        "30-45 minute brisk walk",
        "Swimming",
        "Cycling"
      ]),
      _buildRestDay("Day 7: Complete Rest", [
        "Full recovery day",
        "Focus on nutrition and hydration"
      ]),
    ];
  }

  List<Widget> _buildFullbodyRoutine() {
    return [
      _buildExerciseDay("Day 1: Full Body", [
        "Squats - 2 sets to failure",
        "Bench Press - 2 sets to failure",
        "Bent-over Rows - 2 sets to failure",
        "Overhead Press - 2 sets to failure",
        "Deadlifts - 2 sets to failure"
      ]),
      _buildRestDay("Day 2: Rest", [
        "Complete recovery",
        "Light stretching if needed"
      ]),
      _buildExerciseDay("Day 3: Full Body Repeat", [
        "Front Squats - 2 sets to failure",
        "Incline Bench Press - 2 sets to failure",
        "Pull-Ups - 2 sets to failure",
        "Dumbbell Shoulder Press - 2 sets to failure",
        "Romanian Deadlifts - 2 sets to failure"
      ]),
      _buildRestDay("Day 4: Rest", [
        "Active recovery",
        "30-minute walk or yoga"
      ]),
      _buildExerciseDay("Day 5: Full Body Final", [
        "Lunges - 2 sets to failure",
        "Dips - 2 sets to failure",
        "T-bar Rows - 2 sets to failure",
        "Push Press - 2 sets to failure",
        "Leg Curls - 2 sets to failure"
      ]),
      _buildRestDay("Day 6-7: Weekend Recovery", [
        "Complete rest",
        "Focus on nutrition and hydration",
        "Light mobility work optional"
      ]),
    ];
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              "$title: ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: TColor.primaryText,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseDay(String day, List<String> exercises) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColor.primary,
              ),
            ),
            const SizedBox(height: 10),
            ...exercises.map((exercise) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "➤ $exercise",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRestDay(String day, List<String> activities) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            ...activities.map((activity) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "☁️ $activity",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}