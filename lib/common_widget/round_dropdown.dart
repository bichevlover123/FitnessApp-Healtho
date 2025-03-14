import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// A custom dropdown button with rounded corners and consistent styling
/// This component creates a dropdown menu that fits the app's design language
/// with rounded corners, proper padding, and consistent colors.
class RoundDropDown extends StatelessWidget {
  /// Placeholder text shown when no item is selected
  final String hintText;

  /// List of items to display in the dropdown
  final List list;

  /// Currently selected value
  final dynamic value;

  /// Whether to apply horizontal padding
  final bool isPadding;

  /// Callback function triggered when the selection changes
  final Function(dynamic)? didChange;

  const RoundDropDown({
    super.key,
    required this.hintText,
    required this.list,
    this.value,
    this.isPadding = false,
    this.didChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: isPadding ? 20 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: TColor.txtBG, // Light background color
        border: Border.all(
          color: TColor.board, // Gray border color
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: value,
          icon: Image.asset(
            "assets/img/down.png",
            width: 15,
          ),
          hint: Text(
            hintText,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 15,
            ),
          ),
          items: list
              .map(
                (obj) => DropdownMenuItem(
              value: obj,
              child: Text(
                obj["name"] as String? ?? "",
                style: TextStyle(
                  color: TColor.primaryText,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: didChange,
        ),
      ),
    );
  }
}