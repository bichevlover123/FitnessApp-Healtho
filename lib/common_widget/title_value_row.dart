import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A reusable row widget displaying a title and value in a vertical layout
/// This component creates a vertical arrangement of two text elements:
/// a lighter-colored title at the top and a bold value below it.
class TitleValueRow extends StatelessWidget {
  /// Text displayed as the title (top text)
  final String title;

  /// Text displayed as the value (bottom text)
  final String value;

  const TitleValueRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title text (lighter color, smaller font)
          Text(
            title,
            style: TextStyle(
              color: TColor.placeholder, // Dimmed text color
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          // Value text (primary text color, bold font)
          Text(
            value,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}