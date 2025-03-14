import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A custom tab button for top navigation tabs
/// This component creates a tab button that can be selected or deselected,
/// with visual feedback through color changes and a bottom border.
class TopTabButton extends StatelessWidget {
  /// Text displayed on the button
  final String title;

  /// Indicates whether the tab is currently selected
  final bool isSelect;

  /// Callback function triggered when the button is tapped
  final VoidCallback onPressed;

  const TopTabButton({
    super.key,
    required this.title,
    required this.isSelect,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              // Bottom border color based on selection state
              color: isSelect ? TColor.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            // Text color based on selection state
            color: isSelect ? TColor.primary : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}