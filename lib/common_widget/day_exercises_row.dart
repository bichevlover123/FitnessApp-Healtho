import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// Represents a reusable row widget for displaying daily exercise information
/// This widget displays exercise details in a card-like format with completion status
/// and interactive elements for navigation and status updating.
class DayExerciseRow extends StatelessWidget {
  /// Exercise data containing details about the workout
  /// Expected keys: "image", "name", "sets", "reps", "rest", "is_complete"
  final Map obj;

  /// Callback function triggered when the row is tapped
  final VoidCallback onPressed;

  const DayExerciseRow({
    super.key,
    required this.obj,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: TColor.txtBG, // Light background color
          border: Border.all(
            color: TColor.board, // Gray border color
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
        child: Column(
          children: [
            // Main exercise information section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise thumbnail image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      obj["image"],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 25),
                  // Exercise details section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Exercise name
                        Text(
                          obj["name"],
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Sets information row
                        Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                "Sets",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                obj["sets"],
                                style: TextStyle(
                                  color: TColor.placeholder,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Reps information row
                        Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                "Reps",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                obj["reps"],
                                style: TextStyle(
                                  color: TColor.placeholder,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        // Rest information row
                        Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                "Reset",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                obj["rest"],
                                style: TextStyle(
                                  color: TColor.placeholder,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  // Navigation arrow icon
                  Image.asset(
                    "assets/img/next.png",
                    width: 12,
                    color: TColor.placeholder,
                  )
                ],
              ),
            ),
            // Divider line
            Container(
              color: TColor.board,
              height: 2,
            ),
            // Completion status section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Checkbox icon (checked/unchecked)
                  Image.asset(
                    obj["is_complete"]
                        ? "assets/img/check_tick.png"
                        : "assets/img/uncheck.png",
                    width: 20,
                  ),
                  const SizedBox(width: 8),
                  // Completion status text
                  Text(
                    "Mark as completed",
                    style: TextStyle(
                      color: obj["is_complete"]
                          ? const Color(0xff27AE60) // Green when complete
                          : TColor.placeholder, // Gray when incomplete
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}