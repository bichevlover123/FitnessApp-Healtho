import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/common_widget/round_button.dart';
import 'package:healtho_gym/screen/login/sign_up_screen.dart';

/// Onboarding screen displaying introductory information
/// This screen presents a series of pages with information about the app's features.
/// Users can swipe between pages or use the "Next" button to navigate.
/// The final page has a button to proceed to the sign-up screen.
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  /// Current page index in the onboarding sequence
  int selectPage = 0;

  /// Controller for page view navigation
  PageController controller = PageController();

  /// List of onboarding pages with their content
  List pageArr = [
    {
      "title": "Exercises",
      "subtitle": "To Your Personalized Profile",
      "image": "assets/img/in_1.png"
    },
    {
      "title": "Keep Eye On Health\nTracking",
      "subtitle": "Log & reminder your activities",
      "image": "assets/img/in_2.png"
    },
    {
      "title": "Check Your Progress",
      "subtitle": "An tracking calendar",
      "image": "assets/img/in_3.png"
    },
  ];

  @override
  void initState() {
    super.initState();

    // Update page index when user swipes
    controller.addListener(() {
      setState(() {
        selectPage = controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with skip button
      appBar: AppBar(
        actions: [
          Container(
            alignment: Alignment.center,
            child: RoundButton(
              title: "Skip",
              height: 30,
              fontSize: 12,
              width: 70,
              fontWeight: FontWeight.w300,
              type: RoundButtonType.line,
              onPressed: () {
                // Navigate directly to sign-up screen when skipped
                context.push(const SignUpScreen());
              },
            ),
          ),
        ],
      ),
      // Main content with page view and navigation elements
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Page view containing onboarding content
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: (context, index) {
              var pObj = pageArr[index] as Map? ?? {};

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  // Page title
                  Text(
                    pObj["title"].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // Page subtitle
                  Text(
                    pObj["subtitle"].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 15,
                    ),
                  ),
                  // Page image
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Image.asset(
                      pObj["image"],
                      width: MediaQuery.of(context).size.width * 0.65,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              );
            },
          ),
          // Safe area for bottom navigation elements
          SafeArea(
            child: Column(
              children: [
                const Spacer(
                  flex: 5,
                ),
                // Page indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pageArr.map((e) {
                    var index = pageArr.indexOf(e);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: index == selectPage
                            ? TColor.primary
                            : TColor.inactive,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                // Next button
                RoundButton(
                  title: "Next",
                  width: 150,
                  onPressed: () {
                    if (selectPage >= 2) {
                      // Navigate to sign-up screen on last page
                      context.push(const SignUpScreen());
                    } else {
                      // Move to next page
                      selectPage = selectPage + 1;
                      controller.animateToPage(
                        selectPage,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.bounceInOut,
                      );
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}