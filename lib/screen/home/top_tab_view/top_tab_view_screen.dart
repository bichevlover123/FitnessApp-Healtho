import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/top_tab_button.dart';
import 'package:healtho_gym/screen/home/notification/notification_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/challenges/challenges_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/dietician/dietician_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/health_tip/health_tip_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/trainer/trainer_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/workout_plan_screen.dart';
import 'package:healtho_gym/screen/home/setting/profile_screen.dart';

class TopTabViewScreen extends StatefulWidget {
  const TopTabViewScreen({super.key});

  @override
  State<TopTabViewScreen> createState() => _TopTabViewScreenState();
}

class _TopTabViewScreenState extends State<TopTabViewScreen>
    with SingleTickerProviderStateMixin {
  final List<String> tapArr = [
    "Health Tips",
    "Exercises",
    "Workout Plan",
    "Challenges",
    "Trainers",
    "Dietician"
  ];

  int selectTab = 0;
  TabController? controller;
  String userName = "User"; // Default name if not available

  @override
  void initState() {
    super.initState();
    controller = TabController(length: tapArr.length, vsync: this);
    controller?.addListener(() {
      setState(() {
        selectTab = controller?.index.round() ?? 0;
      });
    });
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (doc.exists && doc.data() != null) {
          setState(() {
            userName = doc.get("name") ?? "User";
          });
        }
      } catch (e) {
        debugPrint("Error fetching user name: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20), // Add right-side spacing
              child: Text(
                "Hello, $userName!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22, // Increased from 18
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Top Tab Bar with increased height and padding.
          Container(
            margin: const EdgeInsets.only(top: 0.5),
            color: TColor.secondary,
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: tapArr.asMap().entries.map((entry) {
                    int index = entry.key;
                    String name = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TopTabButton(
                        title: name,
                        isSelect: selectTab == index,
                        onPressed: () {
                          setState(() {
                            selectTab = index;
                            controller?.animateTo(index);
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          // TabBarView displays the tab content.
          Expanded(
            child: TabBarView(
              controller: controller,
              children: const [
                HealthTipScreen(),
                ExercisesScreen(),
                WorkoutPlanScreen(),
                ChallengesScreen(),
                TrainerTabScreen(),
                DieticianTabScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
