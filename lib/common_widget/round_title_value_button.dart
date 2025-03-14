import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable button widget displaying a title and value in a row format
/// This component creates a rounded button with two text sections:
/// one for a title and one for a value, with interactive functionality.
class RoundTitleValueButton extends StatelessWidget {
  /// Text displayed in the left section of the button
  final String title;

  /// Text displayed in the right section of the button
  final String value;

  /// Callback function triggered when the button is tapped
  final VoidCallback onPressed;

  const RoundTitleValueButton({
    super.key,
    required this.title,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: TColor.txtBG, // Light background color
            border: Border.all(
              color: TColor.board, // Gray border color
              width: 1,
            ),
            borderRadius: BorderRadius.circular(25), // Rounded corners
          ),
          height: 50,
          child: Row(
            children: [
              // Left section for the title text
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.btnSecondaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Right section for the value text
              Expanded(
                flex: 2,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.btnSecondaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}