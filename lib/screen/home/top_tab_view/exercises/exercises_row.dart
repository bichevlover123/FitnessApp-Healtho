import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable row widget for displaying exercise information
/// This component displays an exercise with an image background and text overlay
/// in a card-like format with interactive functionality.
class ExercisesRow extends StatelessWidget {
  /// Exercise data containing details about the workout
  /// Expected keys: "image", "title"
  final Map obj;

  /// Callback function triggered when the row is tapped
  final VoidCallback onPressed;

  const ExercisesRow({
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
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)], // Subtle shadow
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Background image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AspectRatio(
                aspectRatio: 2 / 1, // Maintain 2:1 width-to-height ratio
                child: Image.asset(
                  obj["image"],
                  width: double.maxFinite,
                  height: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Exercise title and action buttons
            Row(
              children: [
                // Exercise title container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  width: context.width * 0.4, // 40% of screen width
                  height: 45,
                  decoration: BoxDecoration(
                    color: TColor.primary, // Primary color background for text
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    obj["title"],
                    maxLines: 1,
                    style: TextStyle(
                      color: TColor.btnPrimaryText, // Text color
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(), // Fill remaining space
                // Placeholder for action buttons
                InkWell(
                  onTap: () {},
                  child: const SizedBox(
                    width: 40,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: const SizedBox(
                    width: 40,
                  ),
                ),
                const SizedBox(width: 8,) // Small spacing at the end
              ],
            )
          ],
        ),
      ),
    );
  }
}