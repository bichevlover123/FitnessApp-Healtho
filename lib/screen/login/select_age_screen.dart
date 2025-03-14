import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// Screen for selecting user's age
/// This screen displays a Cupertino picker (iOS-style wheel picker)
/// allowing users to select their age from 1 to 119 years.
class SelectAgeScreen extends StatefulWidget {
  /// Callback function triggered when the selected age changes
  final Function(dynamic) didChange;

  const SelectAgeScreen({super.key, required this.didChange});

  @override
  State<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  /// List of age options from 1 to 119
  List valueArr = [];

  @override
  void initState() {
    super.initState();

    // Populate age options from 1 to 119
    for (var i = 1; i < 120; i++) {
      valueArr.add({"name": "$i", "value": i});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height,
      color: Colors.black45,
      alignment: Alignment.center,
      child: Container(
        width: context.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title text for the age selection screen
            Text(
              "Select your Age",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // Cupertino picker for selecting age
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (value) {
                        // Call the callback with the selected age
                        widget.didChange(valueArr[value]["name"]);
                      },
                      children: List<Widget>.generate(valueArr.length, (index) {
                        var obj = valueArr[index];

                        return Text("${obj["name"]}");
                      }),
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