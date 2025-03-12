import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:healtho_gym/screen/login/splash_screen.dart';
import 'package:healtho_gym/screen/login/name_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healtho Gym',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Map<String, dynamic>>(
        future: _checkAuthState(),
        builder: (context, snapshot) {
          // Show loading indicator while checking
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Handle errors
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }

          // Get authentication state results
          final isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;
          final isProfileComplete = snapshot.data?['isProfileComplete'] ?? false;

          return isLoggedIn
              ? (isProfileComplete
              ? const TopTabViewScreen()
              : const NameScreen())
              : const SplashScreen();
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _checkAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool('remember_me') ?? false;
      final user = FirebaseAuth.instance.currentUser;

      // Check if we should attempt auto-login
      final shouldAutoLogin = rememberMe && user != null && user.emailVerified;
      if (!shouldAutoLogin) return {'isLoggedIn': false};

      // Check profile completeness
      final isProfileComplete = await _checkProfileComplete(user.uid);

      return {
        'isLoggedIn': true,
        'isProfileComplete': isProfileComplete,
      };
    } catch (e) {
      // Handle any errors in the auth check process
      return {'isLoggedIn': false, 'error': e.toString()};
    }
  }

  Future<bool> _checkProfileComplete(String userId) async {
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      const requiredFields = [
        'name',
        'gender',
        'goal',
        'age',
        'height',
        'weight',
        'level'
      ];

      return requiredFields.every((field) =>
      doc.exists && doc.get(field) != null);
    } catch (e) {
      return false;
    }
  }
}