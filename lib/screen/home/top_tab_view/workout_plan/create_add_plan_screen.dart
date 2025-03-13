import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/round_text_field.dart';

class CreateNewPlanScreen extends StatefulWidget {
  const CreateNewPlanScreen({super.key});

  @override
  State<CreateNewPlanScreen> createState() => _CreateNewPlanScreenState();
}

class _CreateNewPlanScreenState extends State<CreateNewPlanScreen> {
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  String? _selectedGoal;
  String? _selectedSplit;

  final List<Map<String, String>> _goalOptions = [
    {"name": "Losing Weight", "value": "losing_weight"},
    {"name": "Gain Muscle Mass", "value": "muscle_gain"},
    {"name": "Fat Loss", "value": "fat_loss"},
  ];

  final List<Map<String, String>> _splitOptions = [
    {"name": "Push pull legs 2x week", "value": "push_pull_legs_2x_week"},
    {"name": "Push pull legs 1x week", "value": "push_pull_legs_1x_week"},
    {"name": "Upper/Lower 2x week", "value": "upper_lower_2x_week"},
    {"name": "Fullbody 3x week", "value": "fullbody_3x_week"},
  ];

  Future<void> _savePlan(Map<String, dynamic> newPlan) async {
    final prefs = await SharedPreferences.getInstance();
    final existingPlans = prefs.getStringList('workoutPlans') ?? [];
    existingPlans.add(jsonEncode(newPlan));
    await prefs.setStringList('workoutPlans', existingPlans);
  }

  void _addPlan() async {
    if (_planNameController.text.isEmpty ||
        _durationController.text.isEmpty ||
        _selectedGoal == null ||
        _selectedSplit == null) {
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
      final newPlan = {
        'name': _planNameController.text,
        'goal': _selectedGoal!,
        'duration': _durationController.text,
        'split': _selectedSplit!,
      };

      await _savePlan(newPlan);
      if (mounted) Navigator.pop(context, true);

      if (mounted) {
        Navigator.pop(context, true); // Pass success flag
      }
    } catch (e) {
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Image.asset(
            "assets/img/back.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: TColor.secondary,
        centerTitle: false,
        title: const Text(
          "Add Plan",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RoundTextField(
                controller: _planNameController,
                hintText: "Plan Name",
                radius: 10,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: RoundDropDown(
                hintText: "Goal",
                list: _goalOptions,
                selectedValue: _selectedGoal,
                didChange: (value) => setState(() => _selectedGoal = value['value']),
              ),
            ),
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
              )
            ),
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
    _planNameController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}

class RoundDropDown extends StatelessWidget {
  final String hintText;
  final List<Map<String, String>> list;
  final String? selectedValue;
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
        color: TColor.txtBG,
        border: Border.all(color: TColor.board),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, String>>(
          isExpanded: true,
          value: selectedValue != null
              ? list.firstWhere((e) => e['value'] == selectedValue)
              : null,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              selectedValue != null
                  ? list.firstWhere((e) => e['value'] == selectedValue)['name']!
                  : hintText,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 15,
              ),
            ),
          ),
          items: list.map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item['name']!,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
              ),
            ),
          )).toList(),
          onChanged: (value) => didChange(value!),
        ),
      ),
    );
  }
}