import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/screen/login/physique_screen.dart';

/// Screen for selecting user's fitness goal
/// This screen presents a list of fitness goals for the user to select from.
/// The selected goal is saved to Firestore and used in subsequent screens.
class GoalScreen extends StatefulWidget {
  /// User's name passed from previous screen
  final String userName;

  const GoalScreen({super.key, required this.userName});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  /// Currently selected goal
  String selectName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Welcome message with user's name
              Text(
                "Welcome ${widget.userName}!",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              // Instruction text
              Text(
                "Select Your Goal",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              // Expanded section for goal selection buttons
              Expanded(
                child: ListView(
                  children: ["Fat Loss", "Weight Gain", "Muscle Gain", "Others"]
                      .map((name) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: RoundButton(
                        title: name,
                        type: RoundButtonType.line,
                        isPadding: false,
                        // Display selected icon if this goal is selected
                        image: selectName == name
                            ? "assets/img/radio_select.png"
                            : "assets/img/radio_unselect.png",
                        onPressed: () {
                          setState(() {
                            // Update selected goal
                            selectName = name;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Done button to save selection and proceed
              RoundButton(
                title: "DONE",
                isPadding: false,
                onPressed: () async {
                  if (selectName.isEmpty) {
                    // Show error if no goal selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a goal"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // Exit if nothing is selected
                  }

                  // Update user's goal in Firestore
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({'goal': selectName});
                  } catch (e) {
                    // Show error if update fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update goal: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // Navigate to next screen after successful update
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhysiqueScreen(
                        userName: widget.userName,
                        userGoal: selectName,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}