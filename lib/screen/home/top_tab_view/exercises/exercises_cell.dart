import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable cell widget for displaying exercise information
/// This component displays an exercise with an image background and text overlay
/// in a card-like format with interactive functionality.
class ExercisesCell extends StatelessWidget {
  /// Exercise data containing details about the workout
  /// Expected keys: "image", "title", "subtitle"
  final Map obj;

  /// Callback function triggered when the cell is tapped
  final VoidCallback onPressed;

  const ExercisesCell({
    super.key,
    required this.obj,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: TColor.txtBG, // Light background color
          borderRadius: BorderRadius.circular(15), // Rounded corners
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)], // Subtle shadow
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                obj["image"],
                width: double.maxFinite,
                height: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
            // Text overlay container
            Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: TColor.primary, // Primary color background for text
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title text
                  Text(
                    obj["title"],
                    maxLines: 1,
                    style: TextStyle(
                      color: TColor.btnPrimaryText, // Text color
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Subtitle text
                  Text(
                    obj["subtitle"],
                    maxLines: 1,
                    style: TextStyle(
                      color: TColor.btnPrimaryText, // Text color
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}