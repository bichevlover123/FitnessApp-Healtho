import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

class SelectHeightScreen extends StatefulWidget {
  final Function(dynamic) didChange;
  final int initialHeight;

  const SelectHeightScreen({
    Key? key,
    required this.didChange,
    this.initialHeight = 170,
  }) : super(key: key);

  @override
  State<SelectHeightScreen> createState() => _SelectHeightScreenState();
}

class _SelectHeightScreenState extends State<SelectHeightScreen> {
  List valueArr = [];

  @override
  void initState() {
    super.initState();
    // Generate a list of heights from 100 cm to 250 cm.
    for (var i = 100; i <= 250; i++) {
      valueArr.add({"name": "$i", "value": i});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery for screen size info
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      color: Colors.black45,
      alignment: Alignment.center,
      child: Container(
        width: width * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Select your Height (cm)",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      // Set the scroll controller's initialItem based on initialHeight.
                      scrollController: FixedExtentScrollController(
                        initialItem: widget.initialHeight - 100,
                      ),
                      itemExtent: 32,
                      onSelectedItemChanged: (value) {
                        widget.didChange(valueArr[value]["name"]);
                      },
                      children: List<Widget>.generate(valueArr.length, (index) {
                        var obj = valueArr[index];
                        return Center(
                          child: Text(
                            "${obj["name"]}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
