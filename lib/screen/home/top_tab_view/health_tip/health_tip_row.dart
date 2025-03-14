import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable row widget for displaying health tips
/// This component displays a health tip with an image and text overlay
/// in a card-like format with interactive functionality.
class HealthTipRow extends StatelessWidget {
  /// Health tip data containing details about the tip
  /// Expected keys: "image", "title", "subtitle"
  final Map obj;

  /// Callback function triggered when the row is tapped
  final VoidCallback onPressed;

  const HealthTipRow({
    super.key,
    required this.obj,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: TColor.txtBG, // Light background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)], // Subtle shadow
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Image display with padding
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
            ),
            // Text container with title and subtitle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: TColor.txtBG, // Match background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 1)], // Subtle shadow
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title text
                  Text(
                    obj["title"],
                    style: TextStyle(
                      color: TColor.primaryText, // Primary text color
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Subtitle text
                  Text(
                    obj["subtitle"],
                    style: TextStyle(
                      color: TColor.primaryText, // Primary text color
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}