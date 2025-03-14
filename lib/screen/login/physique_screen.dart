import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/round_title_value_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/select_age_screen.dart';
import 'package:healtho_gym/screen/login/select_height_screen.dart';
import 'package:healtho_gym/screen/login/select_level_screen.dart';
import 'package:healtho_gym/screen/login/select_weight_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Screen for collecting user physique details
/// This screen allows users to input their:
/// - Age
/// - Height
/// - Weight
/// - Fitness level
/// The data is saved to Firestore and used throughout the app.
class PhysiqueScreen extends StatefulWidget {
  /// User's name passed from previous screen
  final String userName;

  /// User's selected goal passed from previous screen
  final String userGoal;

  const PhysiqueScreen({
    super.key,
    required this.userName,
    required this.userGoal,
  });

  @override
  State<PhysiqueScreen> createState() => _PhysiqueScreenState();
}

class _PhysiqueScreenState extends State<PhysiqueScreen> {
  /// Currently selected age (default: 19 years)
  String selectAge = "19";

  /// Currently selected height (default: 170 cm)
  String selectHeight = "170 cm";

  /// Currently selected weight (default: 78 KG)
  String selectWeight = "78 KG";

  /// Currently selected fitness level (default: Beginner)
  String selectLevel = "Beginner";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Display user's name and goal
              Text(
                "Hello ${widget.userName}!",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Your goal: ${widget.userGoal}",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Enter Your Physique",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              // Age selection button
              RoundTitleValueButton(
                title: "Age",
                value: "$selectAge Yrs",
                onPressed: () {
                  // Show age selection bottom sheet
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return SelectAgeScreen(didChange: (val) {
                        setState(() {
                          selectAge = val;
                        });
                      });
                    },
                  );
                },
              ),
              // Height selection button
              RoundTitleValueButton(
                title: "Height",
                value: selectHeight,
                onPressed: () {
                  // Show height selection bottom sheet
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return SelectHeightScreen(didChange: (val) {
                        // Update height with new value in centimeters
                        setState(() {
                          selectHeight = "$val cm";
                        });
                      });
                    },
                  );
                },
              ),
              // Weight selection button
              RoundTitleValueButton(
                title: "Weight",
                value: selectWeight,
                onPressed: () {
                  // Show weight selection bottom sheet
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return SelectWeightScreen(didChange: (val) {
                        setState(() {
                          selectWeight = val;
                        });
                      });
                    },
                  );
                },
              ),
              // Fitness level selection button
              RoundTitleValueButton(
                title: "Level",
                value: selectLevel,
                onPressed: () {
                  // Show level selection bottom sheet
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return SelectLevelScreen(didChange: (val) {
                        setState(() {
                          selectLevel = val;
                        });
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
              // Confirm details button
              RoundButton(
                title: "Confirm Detail",
                isPadding: false,
                onPressed: () async {
                  try {
                    // Update user profile in Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      'age': selectAge,
                      'height': selectHeight,
                      'weight': selectWeight,
                      'level': selectLevel,
                    });
                  } catch (e) {
                    // Show error message if update fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to update details: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  // Navigate to main app screen after successful update
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopTabViewScreen(),
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