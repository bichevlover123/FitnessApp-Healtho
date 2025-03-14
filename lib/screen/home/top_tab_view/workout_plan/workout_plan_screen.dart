import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/icon_title_subtitle_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/create_add_plan_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/my_workout_plans_screen.dart';

/// Main workout plan screen providing options to create new plans or manage existing ones
class WorkoutPlanScreen extends StatelessWidget {
  const WorkoutPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main content area with scrolling
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              // Button to create a new workout plan
              IconTitleSubtitleButton(
                title: "Create New Plan",
                subtitle: "Customise workout plans as per your need",
                icon: "assets/img/add_big.png",
                onPressed: () {
                  // Navigate to create new plan screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateNewPlanScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Button to view and manage existing workout plans
              IconTitleSubtitleButton(
                title: "My Workout Plans",
                subtitle: "View and manage your saved workout plans",
                icon: "assets/img/search_circle.png", // Make sure this asset exists or change it.
                onPressed: () {
                  // Navigate to my workout plans screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyWorkoutPlansScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}