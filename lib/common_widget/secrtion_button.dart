import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A section header button widget with "More" option
/// This component creates a horizontal row with a title on the left
/// and a "More" option on the right, typically used as a section header
/// with interactive functionality to navigate to more content.
class SectionButton extends StatelessWidget {
  /// Main title text displayed on the left side
  final String title;

  /// Callback function triggered when the button is tapped
  final VoidCallback onPressed;

  const SectionButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Main title text
            Text(
              title,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            // "More" option text
            Text(
              "More",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 15,
              ),
            )
          ],
        ),
      ),
    );
  }
}