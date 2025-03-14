import 'package:flutter/services.dart'; // Import for input formatters
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A custom text field widget with rounded corners and consistent styling
/// This component creates a text input field that fits the app's design language
/// with rounded corners, proper padding, and consistent colors. It supports various
/// input types and customizations.
class RoundTextField extends StatelessWidget {
  /// Hint text displayed when the field is empty
  final String hintText;

  /// Text editing controller for input management
  final TextEditingController? controller;

  /// Keyboard type for input suggestions
  final TextInputType? keyboardType;

  /// Input formatters for text validation and formatting
  final List<TextInputFormatter>? inputFormatters;

  /// Border radius for the field's corners
  final double radius;

  /// Whether to obscure text (for passwords)
  final bool obscureText;

  /// Optional widget to display on the right side
  final Widget? right;

  /// Whether to apply horizontal padding
  final bool isPadding;

  const RoundTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.radius = 25,
    this.obscureText = false,
    this.right,
    this.isPadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: isPadding ? 20 : 0),
      decoration: BoxDecoration(
        color: TColor.txtBG, // Light background color
        border: Border.all(
          color: TColor.board, // Gray border color
          width: 1,
        ),
        borderRadius: BorderRadius.circular(radius), // Rounded corners
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters, // Text formatting and validation
        obscureText: obscureText,
        style: TextStyle(
          color: TColor.primaryText,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: TColor.placeholder,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: right,
        ),
      ),
    );
  }
}