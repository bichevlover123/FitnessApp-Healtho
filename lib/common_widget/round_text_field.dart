import 'package:flutter/services.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class RoundTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters; // Add this line
  final double radius;
  final bool obscureText;
  final Widget? right;
  final bool isPadding;

  const RoundTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.inputFormatters, // Add this parameter
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
        color: TColor.txtBG,
        border: Border.all(color: TColor.board, width: 1),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters, // Pass to TextField
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