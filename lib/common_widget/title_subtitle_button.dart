import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable button widget with title and subtitle
/// This component displays a button with both a title and subtitle text,
/// centered within a bordered container with interactive functionality.
class TitleSubtitleButton extends StatelessWidget {
  /// Main title text displayed at the top of the button
  final String title;

  /// Subtitle text displayed below the title
  final String subtitle;

  /// Callback function triggered when the button is tapped
  final VoidCallback onPressed;

  const TitleSubtitleButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: TColor.txtBG, // Light background color
            border: Border.all(
              color: TColor.board, // Gray border color
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Main title text
              Text(
                title,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Subtitle text
              Text(
                subtitle,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}