import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/screen/login/physique_screen.dart';

class GoalScreen extends StatefulWidget {
  final String userName;
  const GoalScreen({super.key, required this.userName});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
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
              Text(
                "Welcome ${widget.userName}!",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Select Your Goal",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
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
                        image: selectName == name
                            ? "assets/img/radio_select.png"
                            : "assets/img/radio_unselect.png",
                        onPressed: () {
                          setState(() {
                            selectName = name;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              RoundButton(
                title: "DONE",
                isPadding: false,
                onPressed: () async {
                  if (selectName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a goal"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return; // Exit if nothing is selected
                  }

                  // Firestore update: only runs when this button is pressed
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({'goal': selectName});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update goal: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  // After successfully updating, navigate to the next screen.
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
