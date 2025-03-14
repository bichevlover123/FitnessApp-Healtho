import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';

/// Detailed screen for displaying workout exercise information
/// This screen shows comprehensive details about a specific exercise including:
/// - Image carousel of exercise demonstration
/// - Step-by-step execution instructions
/// - Required equipment
/// - Targeted muscle groups
class WorkoutExercisesDetailScreen extends StatefulWidget {
  /// Title of the exercise
  final String title;

  /// List of execution steps for the exercise
  final List<String> descriptionSteps;

  /// Equipment required for the exercise
  final String equipment;

  /// Muscle groups targeted by the exercise
  final String targetMuscles;

  /// List of image paths for the exercise demonstration
  final List<String> detailImages;

  const WorkoutExercisesDetailScreen({
    super.key,
    required this.title,
    this.descriptionSteps = const [],
    this.equipment = "Not specified",
    this.targetMuscles = "Not specified",
    this.detailImages = const [],
  });

  @override
  State<WorkoutExercisesDetailScreen> createState() =>
      _WorkoutExercisesDetailScreenState();
}

class _WorkoutExercisesDetailScreenState
    extends State<WorkoutExercisesDetailScreen> {
  /// Controller for the image carousel
  PageController pageController = PageController();

  /// Current page index in the image carousel
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar configuration
      appBar: AppBar(
        backgroundColor: TColor.secondary,
        centerTitle: false,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Main content area
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel section with page indicator
            SizedBox(
              height: context.width * 0.8,
              child: Stack(
                children: [
                  // Page view for image carousel
                  PageView.builder(
                    controller: pageController,
                    itemCount: widget.detailImages.length,
                    onPageChanged: (index) {
                      setState(() => currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        child: Image.asset(
                          widget.detailImages[index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  // Page indicator dots if multiple images
                  if (widget.detailImages.length > 1)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.detailImages.length, (index) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index
                                  ? TColor.primary
                                  : Colors.white.withOpacity(0.5),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),

            // Content section with exercise details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise title
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Execution steps header
                  Text(
                    "Execution Steps",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Step-by-step instructions
                  ...widget.descriptionSteps.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Step number indicator
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: TColor.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${widget.descriptionSteps.indexOf(step) + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Step description
                        Expanded(
                          child: Text(
                            step,
                            style: TextStyle(
                              color: TColor.primaryText,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),

                  const SizedBox(height: 24),

                  // Equipment information card
                  _buildInfoCard(
                    title: "Equipment Required",
                    content: widget.equipment,
                    icon: Icons.fitness_center,
                  ),

                  const SizedBox(height: 16),

                  // Target muscles information card
                  _buildInfoCard(
                    title: "Target Muscles",
                    content: widget.targetMuscles,
                    icon: Icons.accessibility_new,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build reusable information card widget
  /// This widget displays a title, content, and icon in a card layout
  Widget _buildInfoCard({required String title, required String content, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TColor.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: TColor.primary),
          ),
          const SizedBox(width: 16),
          // Content section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title text
                Text(
                  title,
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                // Content text
                Text(
                  content,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}