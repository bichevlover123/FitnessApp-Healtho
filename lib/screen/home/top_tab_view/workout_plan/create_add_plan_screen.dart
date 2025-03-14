import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/round_text_field.dart';

/// Screen for creating new workout plans
/// This screen allows users to input details for a new workout plan including:
/// - Plan name
/// - Goal
/// - Duration
/// - Workout split
/// The data is saved locally using SharedPreferences.
class CreateNewPlanScreen extends StatefulWidget {
  const CreateNewPlanScreen({super.key});

  @override
  State<CreateNewPlanScreen> createState() => _CreateNewPlanScreenState();
}

class _CreateNewPlanScreenState extends State<CreateNewPlanScreen> {
  /// Controller for plan name input
  final TextEditingController _planNameController = TextEditingController();

  /// Controller for duration input
  final TextEditingController _durationController = TextEditingController();

  /// Currently selected goal
  String? _selectedGoal;

  /// Currently selected workout split
  String? _selectedSplit;

  /// Available goal options
  final List<Map<String, String>> _goalOptions = [
    {"name": "Losing Weight", "value": "losing_weight"},
    {"name": "Gain Muscle Mass", "value": "muscle_gain"},
    {"name": "Fat Loss", "value": "fat_loss"},
  ];

  /// Available workout split options
  final List<Map<String, String>> _splitOptions = [
    {"name": "Push pull legs 2x week", "value": "push_pull_legs_2x_week"},
    {"name": "Push pull legs 1x week", "value": "push_pull_legs_1x_week"},
    {"name": "Upper/Lower 2x week", "value": "upper_lower_2x_week"},
    {"name": "Fullbody 3x week", "value": "fullbody_3x_week"},
  ];

  /// Save the new workout plan to SharedPreferences
  Future<void> _savePlan(Map<String, dynamic> newPlan) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPlans = prefs.getStringList('workoutPlans') ?? [];
    existingPlans.add(jsonEncode(newPlan));
    await prefs.setStringList('workoutPlans', existingPlans);
  }

  /// Add a new workout plan after validation
  void _addPlan() async {
    // Validate all fields are filled
    if (_planNameController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _selectedGoal == null ||
        _selectedSplit == null) {
      // Show error dialog if any field is missing
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill all fields'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }

    try {
      // Create new plan object
      final newPlan = {
        'name': _planNameController.text,
        'goal': _selectedGoal!,
        'duration': _durationController.text,
        'split': _selectedSplit!,
      };

      // Save the plan
      await _savePlan(newPlan);

      // Navigate back to previous screen
      if (mounted) {
        Navigator.pop(context, true); // Pass success flag
      }
    } catch (e) {
      // Show error message if save fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save plan: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar configuration
      appBar: AppBar(
        // Back button with custom styling
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            "assets/img/back.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
        // App bar background color
        backgroundColor: TColor.secondary,
        // Title configuration
        centerTitle: false,
        title: const Text(
          "Add Plan",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      // Main content area
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            // Plan name input field
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RoundTextField(
                controller: _planNameController,
                hintText: "Plan Name",
                radius: 10,
              ),
            ),
            // Goal selection dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(
                hintText: "Goal",
                list: _goalOptions,
                selectedValue: _selectedGoal,
                didChange: (value) => setState(() => _selectedGoal = value['value']),
              ),
            ),
            // Duration input field
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RoundTextField(
                controller: _durationController,
                hintText: "Duration (2-12 weeks)",
                radius: 10,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only numbers
                  LengthLimitingTextInputFormatter(2), // Max 2 digits
                ],
              ),
            ),
            // Split selection dropdown
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(
                hintText: "Split",
                list: _splitOptions,
                selectedValue: _selectedSplit,
                didChange: (value) => setState(() => _selectedSplit = value['value']),
              ),
            ),
            const SizedBox(height: 30),
            // Create plan button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundButton(
                title: "Create Plan",
                onPressed: _addPlan,
                fontSize: 16,
                height: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    _planNameController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}

/// Custom dropdown button with rounded design
/// This widget creates a dropdown button with rounded corners and
/// proper styling consistent with the app's design language.
class RoundDropDown extends StatelessWidget {
  /// Hint text displayed when no option is selected
  final String hintText;

  /// List of options for the dropdown
  final List<Map<String, String>> list;

  /// Currently selected value
  final String? selectedValue;

  /// Callback when selection changes
  final Function(Map<String, String>) didChange;

  const RoundDropDown({
    super.key,
    required this.hintText,
    required this.list,
    this.selectedValue,
    required this.didChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: TColor.txtBG, // Background color
        border: Border.all(color: TColor.board), // Border styling
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, String>>(
          isExpanded: true,
          // Determine currently selected value
          value: selectedValue != null
              ? list.firstWhere((e) => e['value'] == selectedValue)
              : null,
          // Hint text when no option is selected
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              selectedValue != null
                  ? list.firstWhere((e) => e['value'] == selectedValue)['name']!
                  : hintText,
              style: TextStyle(
                color: TColor.secondaryText, // Text color
                fontSize: 15,
              ),
            ),
          ),
          // Dropdown menu items
          items: list.map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item['name']!,
              style: TextStyle(
                color: TColor.primaryText, // Text color
                fontSize: 15,
              ),
            ),
          )).toList(),
          // Callback when selection changes
          onChanged: (value) => didChange(value!),
        ),
      ),
    );
  }
}