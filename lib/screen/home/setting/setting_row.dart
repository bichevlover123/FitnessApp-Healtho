import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable row widget for settings screens
/// This component displays a row with an icon, title, and value,
/// typically used in settings screens for various configuration options.
class SettingRow extends StatelessWidget {
  /// Title text displayed in the row
  final String title;

  /// Path to the icon asset
  final String icon;

  /// Value text displayed on the right side
  final String value;

  /// Whether the icon should be displayed in a circular shape
  final bool isIconCircle;

  /// Callback function triggered when the row is tapped
  final VoidCallback onPressed;

  const SettingRow({
    super.key,
    required this.title,
    required this.icon,
    this.value = "",
    this.isIconCircle = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: TColor.txtBG, // Light background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        child: Row(
          children: [
            // Icon display with optional circular shape
            ClipRRect(
              borderRadius: BorderRadius.circular(isIconCircle ? 15 : 0),
              child: Image.asset(
                icon,
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(width: 20),
            // Title text
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Value text
            Text(
              value,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}