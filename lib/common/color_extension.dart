import 'package:flutter/material.dart';

// This file defines the application's color theme and provides extension methods
// for simplified navigation and screen size access throughout the Flutter app.

/// Theme color constants for the application
/// Centralizes all color definitions for consistent theming across the app
class TColor {
  // Primary brand colors
  static Color get primary => const Color(0xffF1C40E); // Main accent color
  static Color get secondary => const Color(0xff102B46); // Secondary accent color

  // Text colors
  static Color get primaryText => const Color(0xff0C0B0B); // Primary text color
  static Color get secondaryText => const Color(0xff2C3E50); // Secondary text color
  static Color get btnPrimaryText => const Color(0xff0D0C0C); // Button primary text
  static Color get btnSecondaryText => const Color(0xff241111); // Button secondary text

  // Background colors
  static Color get board => const Color(0xffD4D4D4); // Board/background element color
  static Color get txtBG => const Color(0xffFCFBFB); // Text field background
  static Color get btnBG => const Color(0xffF0F0F3); // Button background

  // Special colors
  static Color get inactive => primaryText.withOpacity(0.2); // Dimmed/inactive state
  static Color get placeholder => const Color(0xff94A5A6); // Placeholder text color
}

/// Extension methods for BuildContext to simplify common operations
/// Provides convenient access to media query data and navigation
extension AppContext on BuildContext {
  // Screen size utilities
  Size get size => MediaQuery.sizeOf(this); // Get full screen size
  double get width => size.width; // Screen width shortcut
  double get height => size.height; // Screen height shortcut

  // Navigation helpers
  Future push(Widget widget) async {
    // Simplified route pushing with default MaterialPageRoute
    return Navigator.push(
        this, MaterialPageRoute(builder: (context) => widget));
  }

  Future pop() async {
    // Simplified route popping
    return Navigator.pop(this);
  }
}