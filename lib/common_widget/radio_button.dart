import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A custom radio button widget with text label
/// This component displays a circular radio button that can be selected or deselected
/// with visual feedback and interactive functionality.
class RadioButton extends StatelessWidget {
  /// Text label displayed next to the radio button
  final String title;

  /// Indicates whether the radio button is currently selected
  final bool isSelect;

  /// Callback function triggered when the radio button is tapped
  final VoidCallback onPressed;

  const RadioButton({
    super.key,
    required this.title,
    required this.isSelect,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            // Radio button circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelect ? TColor.primary : TColor.inactive,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 20),
            // Text label
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}