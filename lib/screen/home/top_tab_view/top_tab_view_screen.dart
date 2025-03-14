import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/top_tab_button.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_tab_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/health_tip/health_tip_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/weight_monitor/weight_monitor_screen.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/workout_plan_screen.dart';
import 'package:healtho_gym/screen/home/setting/profile_screen.dart';

/// Configuration for each tab in the top tab view
class TabConfig {
  /// Title displayed for the tab
  final String title;

  /// Screen widget associated with the tab
  final Widget screen;

  const TabConfig(this.title, this.screen);
}

/// Main screen with top tabs for different fitness sections
class TopTabViewScreen extends StatefulWidget {
  const TopTabViewScreen({super.key});

  @override
  State<TopTabViewScreen> createState() => _TopTabViewScreenState();
}

class _TopTabViewScreenState extends State<TopTabViewScreen>
    with SingleTickerProviderStateMixin {
  /// List of tab configurations
  static const List<TabConfig> _tabConfigs = [
    TabConfig("Health Tips",  HealthTipScreen()),
    TabConfig("Exercises",  ExercisesScreen()),
    TabConfig("Workout Plan",  WorkoutPlanScreen()),
    TabConfig("Weight Monitor",  WeightMonitorScreen()),
  ];

  /// Tab controller for managing the tab selection
  late final TabController _tabController;

  /// Currently selected tab index
  int _selectedTabIndex = 0;

  /// Current user name (default: "User")
  String _userName = "User";

  @override
  void initState() {
    super.initState();
    // Initialize tab controller
    _tabController = TabController(
      length: _tabConfigs.length,
      vsync: this,
    )..addListener(_handleTabChange);
    // Fetch user name from Firestore
    _fetchUserName();
  }

  @override
  void dispose() {
    // Clean up tab controller listener and dispose controller
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  /// Handle tab changes when user swipes
  void _handleTabChange() {
    if (_tabController.index != _selectedTabIndex) {
      setState(() => _selectedTabIndex = _tabController.index);
    }
  }

  /// Fetch user name from Firestore
  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final name = doc.get("name") as String?;
        if (name?.isNotEmpty ?? false) {
          setState(() => _userName = name!);
        }
      }
    } catch (e) {
      debugPrint("Error fetching user name: $e");
    }
  }

  /// Handle tab button press
  void _onTabPressed(int index) {
    if (index != _selectedTabIndex) {
      setState(() {
        _selectedTabIndex = index;
        _tabController.animateTo(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabConfigs.map((config) => config.screen).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the app bar with user greeting and settings button
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: TColor.secondary,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Hello, $_userName!",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the top tab bar with custom buttons
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 0.5),
      color: TColor.secondary,
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: _tabConfigs.asMap().entries.map((entry) {
            final index = entry.key;
            final config = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TopTabButton(
                title: config.title,
                isSelect: _selectedTabIndex == index,
                onPressed: () => _onTabPressed(index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}