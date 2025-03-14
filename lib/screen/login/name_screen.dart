import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/screen/login/goal_screen.dart';
import 'package:healtho_gym/screen/login/login_screen.dart';

/// Screen for collecting user's name and gender
/// This screen is displayed after login if the user's profile is incomplete.
/// It collects the user's name and gender and saves them to Firestore.
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  /// Controller for the name input field
  final TextEditingController _nameController = TextEditingController();

  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Currently selected gender
  String _selectedGender = "";

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in, otherwise redirect to login screen
    if (_auth.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to access this screen'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                // Name input section
                Text(
                  "Enter Your Name",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "i.e. Code For Any",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Gender selection section
                Text(
                  "Select Your Gender",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Male selection button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedGender = "Male";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedGender == "Male"
                              ? TColor.primary
                              : TColor.primary.withAlpha(153),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          "Male",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Female selection button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedGender = "Female";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedGender == "Female"
                              ? TColor.primary
                              : TColor.primary.withAlpha(153),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          "Female",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Next button to proceed to goal selection
                RoundButton(
                  title: "NEXT",
                  isPadding: false,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedGender.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select your gender"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      try {
                        // Update user profile in Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(_auth.currentUser!.uid)
                            .update({
                          'name': _nameController.text,
                          'gender': _selectedGender,
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update details: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      // Navigate to goal selection screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoalScreen(
                            userName: _nameController.text,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}