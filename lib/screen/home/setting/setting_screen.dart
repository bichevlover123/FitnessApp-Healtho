import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/setting/profile_screen.dart';
import 'package:healtho_gym/screen/home/setting/setting_row.dart';
import 'package:healtho_gym/screen/login/login_screen.dart';

/// Settings screen for the application
/// This screen provides various configuration options including profile management,
/// language settings, notifications, and logout functionality.
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  /// Handles user logout
  /// This method signs out the current user from Firebase Authentication
  /// and navigates to the login screen while clearing the navigation stack.
  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen and clear all previous routes
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false
      );
    } catch (e) {
      // Show error message if logout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  /// Shows logout confirmation dialog
  /// This method displays an alert dialog asking the user to confirm logout.
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          // Logout button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App bar configuration
        backgroundColor: TColor.secondary,
        centerTitle: false,
        // Remove back button
        leading: Container(),
        title: const Text(
          "Setting",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // Profile setting row
          SettingRow(
              title: "Profile",
              icon: "assets/img/user_placeholder.png",
              isIconCircle: true,
              onPressed: () {
                // Navigate to profile screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()));
              }),
          // Language options setting row
          SettingRow(
              title: "Language options",
              icon: "assets/img/language.png",
              value: "Eng",
              onPressed: () {}),
          // Notification setting row
          SettingRow(
              title: "Notification",
              icon: "assets/img/notification.png",
              value: "On",
              onPressed: () {}),
          // Logout setting row
          SettingRow(
              title: "Log Out",
              icon: "assets/img/logout.png",
              value: "",
              onPressed: _showLogoutConfirmation),
        ],
      ),
    );
  }
}