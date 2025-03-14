import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// Enum to define different button types for RoundButton
enum RoundButtonType { primary, line }

/// A reusable rounded button widget with customizable styles
/// This component creates a button with rounded corners that can be configured
/// as a primary action button or an outlined button. It supports both text-only
/// and image-with-text configurations.
class RoundButton extends StatelessWidget {
  /// Text displayed on the button
  final String title;

  /// Type of the button (primary or line)
  final RoundButtonType type;

  /// Height of the button
  final double height;

  /// Font size of the button text
  final double fontSize;

  /// Font weight of the button text
  final FontWeight fontWeight;

  /// Width of the button
  final double width;

  /// Optional image asset path
  final String? image;

  /// Whether to apply horizontal padding
  final bool isPadding;

  /// Border radius of the button
  final double radius;

  /// Callback function triggered when the button is tapped
  final VoidCallback onPressed;

  const RoundButton({
    Key? key,
    required this.title,
    this.type = RoundButtonType.primary,
    this.height = 50,
    this.fontSize = 14,
    this.radius = 25,
    this.fontWeight = FontWeight.w600,
    this.width = double.maxFinite,
    this.isPadding = true,
    required this.onPressed,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isPadding ? 20 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: width,
        decoration: BoxDecoration(
          // Background color based on button type
          color: type == RoundButtonType.primary ? TColor.primary : TColor.txtBG,
          // Border for line type buttons
          border: type == RoundButtonType.line ? Border.all(color: TColor.board) : null,
          borderRadius: BorderRadius.circular(radius),
        ),
        height: height,
        child: Row(
          children: [
            // Optional image on the left side
            if (image != null)
              SizedBox(
                width: 60,
                child: Image.asset(
                  image!,
                  width: 20,
                  height: 20,
                ),
              ),
            // Text content
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  // Text color based on button type
                  color: type == RoundButtonType.primary ? TColor.btnPrimaryText : TColor.btnSecondaryText,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ),
            // Spacer if image is present
            if (image != null)
              Container(
                width: 60,
              ),
          ],
        ),
      ),
    );
  }
}

/// A variation of RoundButton with left-aligned text
/// This component is similar to RoundButton but with text aligned to the left
/// instead of centered, making it suitable for contexts where left alignment
/// is preferred for better readability.
class RoundSelectButton extends StatelessWidget {
  /// Text displayed on the button
  final String title;

  /// Type of the button (primary or line)
  final RoundButtonType type;

  /// Height of the button
  final double height;

  /// Font size of the button text
  final double fontSize;

  /// Font weight of the button text
  final FontWeight fontWeight;

  /// Width of the button
  final double width;

  /// Optional image asset path
  final String? image;

  /// Whether to apply horizontal padding
  final bool isPadding;

  /// Callback function triggered when the button is tapped
  final VoidCallback onPressed;

  const RoundSelectButton({
    Key? key,
    required this.title,
    this.type = RoundButtonType.primary,
    this.height = 50,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.width = double.maxFinite,
    this.isPadding = true,
    required this.onPressed,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isPadding ? 20 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: width,
        decoration: BoxDecoration(
          // Background color based on button type
          color: type == RoundButtonType.primary ? TColor.primary : TColor.txtBG,
          // Border for line type buttons
          border: type == RoundButtonType.line ? Border.all(color: TColor.board) : null,
          borderRadius: BorderRadius.circular(25),
        ),
        height: height,
        child: Row(
          children: [
            // Optional image on the left side
            if (image != null)
              SizedBox(
                width: 60,
                child: Image.asset(
                  image!,
                  width: 20,
                  height: 20,
                ),
              ),
            // Text content with left alignment
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  // Text color based on button type
                  color: type == RoundButtonType.primary ? TColor.btnPrimaryText : TColor.btnSecondaryText,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                ),
              ),
            ),
            // Spacer if image is present
            if (image != null)
              Container(
                width: 60,
              ),
          ],
        ),
      ),
    );
  }
}