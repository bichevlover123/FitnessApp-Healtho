import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// Detailed screen for displaying health tips
/// This screen shows a health tip with an image, title, and detailed points.
/// It includes navigation back functionality and options to favorite/share the tip.
class HealthTipDetailScreen extends StatefulWidget {
  const HealthTipDetailScreen({super.key});

  @override
  State<HealthTipDetailScreen> createState() => _HealthTipDetailScreenState();
}

class _HealthTipDetailScreenState extends State<HealthTipDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar configuration
      appBar: AppBar(
        // Back button with custom styling
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
        // App bar background color
        backgroundColor: TColor.secondary,
        // Title configuration
        centerTitle: false,
        title: const Text(
          "Health Tip",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      // Main content area
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image display with rounded corners
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/img/home_1.png",
                      width: double.maxFinite,
                      // Calculate height based on screen width for responsive design
                      height: context.width * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // Main title of the health tip
                  Text(
                    "A Diet Without Exercise is Useless",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // First point of the health tip
                  Text(
                    "1) Interval Training is a form of exercise in which you alternate between two or more different exercise . This Consist of doing an exercise at a very high  level intensity for a short bursts.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Second point of the health tip
                  Text(
                    "2) Some high intensity interval training is a great way to burn calories and lose weight.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Third point of the health tip
                  Text(
                    "3) Another great thing is about interval training is that it is extremely time efficient. It does not make any time to get into shape when you practice high intensity interval training.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Fourth point of the health tip
                  Text(
                    "4) Exercise, especially high intensity interval training, is awesome because it keeps you younger for longer....",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Fifth point of the health tip
                  Text(
                    "5) Interval Training is a form of exercise in which you alternate between two or more different exercise . This Consist of doing an exercise at a very high  level intensity for a short bursts.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Sixth point of the health tip
                  Text(
                    "6) Some high intensity interval training is a great way to burn calories and lose weight.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Seventh point of the health tip
                  Text(
                    "7) Another great thing is about interval training is that it is extremely time efficient. It does not make any time to get into shape when you practice high intensity interval training.",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Eighth point of the health tip
                  Text(
                    "8) Exercise, especially high intensity interval training, is awesome because it keeps you younger for longer….",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // Floating action button for favorite and share actions
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
              ),
            ]),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Favorite button
            InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/img/fav_color.png",
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            // Share button
            InkWell(
              onTap: () {},
              child: Image.asset(
                "assets/img/share.png",
                width: 25,
                height: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}