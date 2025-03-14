import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable button widget with icon, title, and subtitle
/// This component displays a button with left-aligned icon and text content
/// that can be used for navigation or actions throughout the app.
class IconTitleSubtitleButton extends StatelessWidget {
  /// Main title text displayed in the button
  final String title;

  /// Subtitle text displayed below the title
  final String subtitle;

  /// Path to the icon asset
  final String icon;

  /// Callback function triggered when the button is tapped
  final VoidCallback onPressed;

  const IconTitleSubtitleButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: TColor.btnBG, // Light button background color
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Row(
            children: [
              // Icon display area
              Image.asset(
                icon,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 15),
              // Text content area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
        ),
      ),
    );
  }
}