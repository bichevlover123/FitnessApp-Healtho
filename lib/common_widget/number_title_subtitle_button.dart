import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable button widget with number, title, and subtitle
/// This component displays a button with a numbered indicator, main title,
/// subtitle, and navigation arrow that can be used for sequential actions
/// or navigation throughout the app.
class NumberTitleSubtitleButton extends StatelessWidget {
  /// Main title text displayed in the button
  final String title;

  /// Subtitle text displayed below the title
  final String subtitle;

  /// Number displayed at the start of the button
  final String number;

  /// Callback function triggered when the button is tapped
  final VoidCallback onPressed;

  const NumberTitleSubtitleButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.number,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            color: TColor.txtBG, // Light background color
            border: Border.all(
              color: TColor.board, // Gray border color
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number display area
                    Text(
                      number,
                      style: TextStyle(
                        color: TColor.placeholder, // Dimmed text color
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
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
              // Navigation arrow icon
              Image.asset(
                "assets/img/next.png",
                width: 10,
                color: TColor.secondaryText,
              )
            ],
          ),
        ),
      ),
    );
  }
}