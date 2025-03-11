import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/common_widget/round_title_value_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/select_age_screen.dart';
import 'package:healtho_gym/screen/login/select_height_screen.dart'; // Updated widget
import 'package:healtho_gym/screen/login/select_level_screen.dart';
import 'package:healtho_gym/screen/login/select_weight_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhysiqueScreen extends StatefulWidget {
  final String userName;
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
  String selectAge = "19"; // default value in years
  String selectHeight = "170 cm"; // default in centimeters
  String selectWeight = "78 KG";
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
              // Display the user's name and selected goal
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
              // Button to select Age
              RoundTitleValueButton(
                title: "Age",
                value: "$selectAge Yrs",
                onPressed: () {
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
              // Button to select Height in cm, with our updated selector.
              RoundTitleValueButton(
                title: "Height",
                value: selectHeight,
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return SelectHeightScreen(didChange: (val) {
                        // Now the value returned is in centimeters.
                        setState(() {
                          selectHeight = "$val cm";
                        });
                      });
                    },
                  );
                },
              ),
              // Button to select Weight
              RoundTitleValueButton(
                title: "Weight",
                value: selectWeight,
                onPressed: () {
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
              // Button to select Level
              RoundTitleValueButton(
                title: "Level",
                value: selectLevel,
                onPressed: () {
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
              // Confirm Detail button: sends selected details to Firestore when pressed.
              RoundButton(
                title: "Confirm Detail",
                isPadding: false,
                onPressed: () async {
                  try {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to update details: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  // After a successful update, navigate to TopTabViewScreen.
                  // (Adjust navigation method as needed.)
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
