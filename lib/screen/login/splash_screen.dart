import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healtho_gym/screen/login/on_boarding_screen.dart';
import 'package:healtho_gym/screen/login/login_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/top_tab_view_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set the system UI to immersive.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Show the splash screen for 3 seconds.
    await Future.delayed(const Duration(seconds: 3));

    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    // Check if the user has completed onboarding.
    // (Ensure you set "onboarding_done" to true in your onboarding flow once complete.)
    final hasOnboarded = prefs.getBool("onboarding_done") ?? false;

    if (!hasOnboarded) {
      // Navigate to the onboarding screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      );
      return;
    }

    // Otherwise, check if the user is logged in.
    final isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        isLoggedIn ? const TopTabViewScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Display the app logo at 65% of screen width.
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/img/app_logo.png",
          width: MediaQuery.of(context).size.width * 0.65,

        ),
      ),
    );
  }
}
