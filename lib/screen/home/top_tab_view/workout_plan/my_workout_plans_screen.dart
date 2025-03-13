import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/workout_plan_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/create_add_plan_screen.dart';

class MyWorkoutPlansScreen extends StatefulWidget {
  const MyWorkoutPlansScreen({super.key});

  @override
  State<MyWorkoutPlansScreen> createState() => _MyWorkoutPlansScreenState();
}

class _MyWorkoutPlansScreenState extends State<MyWorkoutPlansScreen> {
  List<Map<String, dynamic>> _workoutPlans = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPlans());
  }

  Future<void> _loadPlans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final plans = prefs.getStringList('workoutPlans') ?? [];

      setState(() {
        _workoutPlans = plans.map((jsonString) {
          try {
            final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
            return {
              'name': decoded['name']?.toString() ?? 'Unnamed Plan',
              'goal': decoded['goal']?.toString() ?? 'No Goal',
              'duration': decoded['duration']?.toString() ?? '0',
              'split': decoded['split']?.toString() ?? 'No Split',
            };
          } catch (e) {
            print("Error decoding plan: $e");
            return <String, dynamic>{};
          }
        }).where((plan) => plan.isNotEmpty).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading plans: ${e.toString()}')),
      );
    }
  }

  Future<void> _deletePlan(int index) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> plans = prefs.getStringList('workoutPlans') ?? [];
      if (index >= 0 && index < plans.length) {
        plans.removeAt(index);
        await prefs.setStringList('workoutPlans', plans);
        await _loadPlans();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting plan: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Workout Plans"),
        backgroundColor: TColor.secondary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNewPlanScreen(),
            ),
          );
          if (result == true) await _loadPlans();
        },
        backgroundColor: TColor.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _workoutPlans.isEmpty
          ? Center(
        child: Text(
          "No workout plans found.\nStart by creating a new plan!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: TColor.primaryText.withOpacity(0.6),
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: _workoutPlans.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final plan = _workoutPlans[index];
            return Dismissible(
              key: Key('${plan['name']}_$index'), // Unique key with index
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Plan'),
                    content: const Text('Are you sure you want to delete this plan?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (direction) => _deletePlan(index),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutPlanDetailScreen(plan: plan),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: TColor.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.fitness_center, color: TColor.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan['name'],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: TColor.primaryText),
                              ),
                              const SizedBox(height: 8),
                              _buildDetailRow('Goal', plan['goal']),
                              _buildDetailRow('Split', plan['split']),
                              const SizedBox(height: 8),
                              Text(
                                '${plan['duration']} weeks',
                                style: TextStyle(
                                    color: TColor.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: TColor.secondaryText),
                          onPressed: () => _deletePlan(index),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 14),
          ),
          Text(
            value.isNotEmpty ? value : 'Not specified',
            style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}