import 'package:flutter/material.dart';
import 'package:healtho_gym/common/color_extension.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_row.dart';
import 'package:healtho_gym/screen/home/top_tab_view/workout_plan/workout_exercises_screen.dart';

/// Screen displaying a list of exercises for a specific muscle group
/// This screen takes a muscle group index and title, then displays
/// a filtered list of exercises with their details. Users can tap on
/// exercises to view more information.
class ExercisesNameScreen extends StatefulWidget {
  /// Index of the muscle group to display
  final int muscleGroupIndex;

  /// Title of the muscle group
  final String groupTitle;

  const ExercisesNameScreen({
    super.key,
    required this.muscleGroupIndex,
    required this.groupTitle,
  });
  @override
  State<ExercisesNameScreen> createState() => _ExercisesNameScreenState();
}


class _ExercisesNameScreenState extends State<ExercisesNameScreen> {
  /// List of all exercises with their details
  /// Each exercise contains:
  /// - title: Name of the exercise
  /// - image: Thumbnail image path
  /// - detail_images: List of detailed image paths
  /// - description_steps: Exercise steps
  /// - equipment: Required equipment
  /// - target_muscles: Muscles worked
  List listArr = [
    {
      "title": "Bench press",
      "image": "assets/img/l_1.png",
      "detail_images": ["assets/img/l_1.png"],
      "description_steps": [
        " Lie back on a flat bench.",
        " Grip the barbell with a medium grip and lift it off the rack.",
        " Lower the bar to your chest and press it back up."
      ],
      "equipment": "Barbell, Bench, Plate, Lock",
      "target_muscles": "Chest, Shoulders, Triceps"
    },
    {
      "title": "Incline press",
      "image": "assets/img/l_2.png",
      "detail_images": ["assets/img/l_2.png"],
      "description_steps": [
        " Set an adjustable bench to a 30-45 degree incline.",
        " Grip the barbell slightly wider than shoulder-width.",
        " Lower the bar to upper chest and press back up."
      ],
      "equipment": "Adjustable Bench, Barbell",
      "target_muscles": "Upper Chest, Front Deltoids"
    },
    {
      "title": "Decline Press",
      "image": "assets/img/l_3.png",
      "detail_images": ["assets/img/l_3.png"],
      "description_steps": [
        " Lie on a decline bench with a firm grip on the barbell.",
        " Lower the bar slowly to your lower chest.",
        " Press the bar back up until your arms are fully extended."
      ],
      "equipment": "Barbell, Decline Bench",
      "target_muscles": "Lower Chest"
    },
    {
      "title": "Dumbbell Flys",
      "image": "assets/img/l_4.png",
      "detail_images": ["assets/img/l_4.png"],
      "description_steps": [
        " Lie back on a flat bench with a dumbbell in each hand.",
        " With slightly bent elbows, open your arms wide until they are parallel to the floor.",
        " Return the dumbbells to the starting position by squeezing your chest."
      ],
      "equipment": "Dumbbells, Bench",
      "target_muscles": "Chest"
    },
    {
      "title": "Cable Crossovers",
      "image": "assets/img/l_5.png",
      "detail_images": ["assets/img/l_5.png"],
      "description_steps": [
        " Stand in the center of a cable machine.",
        " Grab both cable handles and extend your arms outwards.",
        " Pull your hands together in front of you and return slowly."
      ],
      "equipment": "Cable Machine",
      "target_muscles": "Chest"
    },

    // Back Exercises
    {
      "title": "Lat Pulldown",
      "image": "assets/img/LatPulldowns.png",
      "detail_images": ["assets/img/LatPulldowns.png"],
      "description_steps": [
        " Sit at the lat pulldown machine with your knees secured.",
        " Grip the bar with a wide grip and pull it down to your chest.",
        " Slowly return the bar to the starting position."
      ],
      "equipment": "Lat Pulldown Machine",
      "target_muscles": "Lats, Upper Back"
    },
    {
      "title": "Deadlift",
      "image": "assets/img/deadlift.png",
      "detail_images": ["assets/img/deadlift.png"],
      "description_steps": [
        " Stand with your mid-foot under the barbell.",
        " Bend your hips and knees to grab the bar.",
        " Lift the bar by extending your hips and knees until you’re fully upright."
      ],
      "equipment": "Barbell, Plates",
      "target_muscles": "Back, Glutes, Hamstrings"
    },
    {
      "title": "Bent Over Row",
      "image": "assets/img/BentOverRol.png",
      "detail_images": ["assets/img/BentOverRol.png"],
      "description_steps": [
        " Bend over at the hips with a slight knee bend.",
        " Grip the barbell with both hands.",
        " Pull the bar towards your lower chest, then lower it slowly."
      ],
      "equipment": "Barbell",
      "target_muscles": "Upper Back, Lats"
    },
    {
      "title": "Pull-Up",
      "image": "assets/img/pullups1.png",
      "detail_images": ["assets/img/pullups1.png"],
      "description_steps": [
        " Grip the pull-up bar with hands slightly wider than shoulder-width.",
        " Pull your chest towards the bar until your chin is above it.",
        " Lower yourself slowly back to the starting position."
      ],
      "equipment": "Pull-Up Bar",
      "target_muscles": "Back, Biceps"
    },
    {
      "title": "T-Bar Row",
      "image": "assets/img/TbarRow.png",
      "detail_images": ["assets/img/TbarRow.png"],
      "description_steps": [
        " Stand over a T-Bar row machine.",
        " Grip the handle and row the weight towards your chest.",
        " Slowly lower the weight down."
      ],
      "equipment": "T-Bar Row Machine",
      "target_muscles": "Back, Lats"
    },

    // Biceps Exercises
    {
      "title": "Barbell Curl",
      "image": "assets/img/BarbellCurl.png",
      "detail_images": ["assets/img/BarbellCurl.png"],
      "description_steps": [
        " Stand with your feet shoulder-width apart holding a barbell.",
        " Curl the barbell upward by contracting your biceps.",
        " Lower the barbell slowly back to the starting position."
      ],
      "equipment": "Barbell",
      "target_muscles": "Biceps"
    },
    {
      "title": "Hammer Curl",
      "image": "assets/img/HammerCurl.png",
      "detail_images": ["assets/img/HammerCurl.png"],
      "description_steps": [
        " Stand holding dumbbells with your palms facing your torso.",
        " Curl the weights while keeping your palms facing each other.",
        " Lower the weights slowly."
      ],
      "equipment": "Dumbbells",
      "target_muscles": "Biceps, Forearms"
    },
    {
      "title": "Preacher Curl",
      "image": "assets/img/PreacherCurl.png",
      "detail_images": ["assets/img/PreacherCurl.png"],
      "description_steps": [
        " Sit on a preacher bench and hold a barbell or dumbbells.",
        " Curl the weight upward focusing on the biceps.",
        " Lower the weight under control."
      ],
      "equipment": "Preacher Bench, Barbell/Dumbbells",
      "target_muscles": "Biceps"
    },
    {
      "title": "Concentration Curl",
      "image": "assets/img/ConcentrationCurl.png",
      "detail_images": ["assets/img/ConcentrationCurl.png"],
      "description_steps": [
        " Sit on a bench with legs spread and a dumbbell in one hand.",
        " Rest your elbow on your inner thigh and curl the dumbbell.",
        " Lower it slowly back to the starting position."
      ],
      "equipment": "Dumbbell",
      "target_muscles": "Biceps"
    },
    {
      "title": "Cable Curl",
      "image": "assets/img/cablecurl.png",
      "detail_images": ["assets/img/cablecurl.png"],
      "description_steps": [
        " Stand facing a cable machine with a handle attachment.",
        " Curl the handle towards your shoulder.",
        " Slowly return to the starting position."
      ],
      "equipment": "Cable Machine",
      "target_muscles": "Biceps"
    },

    // Triceps Exercises
    {
      "title": "Tricep Dips",
      "image": "assets/img/tricepDips.png",
      "detail_images": ["assets/img/tricepDips.png"],
      "description_steps": [
        " Use parallel bars or a bench to perform dips.",
        " Lower your body until your elbows are at 90°.",
        " Push yourself back up to the starting position."
      ],
      "equipment": "Parallel Bars or Bench",
      "target_muscles": "Triceps"
    },
    {
      "title": "Skull Crushers",
      "image": "assets/img/skullCrushers.png",
      "detail_images": ["assets/img/skullCrushers.png"],
      "description_steps": [
        " Lie on a flat bench holding an EZ-bar.",
        " Lower the bar towards your forehead carefully.",
        " Extend your arms back to the start."
      ],
      "equipment": "EZ-Bar, Bench",
      "target_muscles": "Triceps"
    },
    {
      "title": "Tricep Pushdown",
      "image": "assets/img/TricepPushdowns.png",
      "detail_images": ["assets/img/TricepPushdowns.png"],
      "description_steps": [
        " Attach a rope or bar to the high pulley of a cable station",
        " Stand facing the machine and grip the attachment with both hands",
        " Push down until your arms are fully extended and slowly return to the starting position"
      ],
      "equipment": "Cable Machine, Rope or Bar Attachment",
      "target_muscles": "Triceps"
    },
    {
      "title": "Overhead Extension",
      "image": "assets/img/overheadT.png",
      "detail_images": ["assets/img/overheadT.png"],
      "description_steps": [
        " Hold a dumbbell with both hands and sit on a bench",
        " Lift the dumbbell overhead with your arms fully extended",
        " Lower the dumbbell behind your head and then press back up"
      ],
      "equipment": "Dumbbell, Bench",
      "target_muscles": "Triceps"
    },
    {
      "title": "Close Grip Press",
      "image": "assets/img/closegripbenchpress.png",
      "detail_images": ["assets/img/closegripbenchpress.png"],
      "description_steps": [
        " Lie on a bench and grip the barbell with your hands shoulder-width apart",
        " Lower the bar to your chest and press back up",
        " Keep your elbows close to your body throughout the movement"
      ],
      "equipment": "Barbell, Bench",
      "target_muscles": "Triceps, Chest"
    },
    {
      "title": "Overhead Press",
      "image": "assets/img/OverheadPress.png",
      "detail_images": ["assets/img/OverheadPress.png"],
      "description_steps": [
        " Stand with your feet shoulder-width apart and grip the barbell slightly wider than shoulder-width",
        " Press the bar overhead until your arms are fully extended",
        " Lower the bar back to your shoulders and repeat"
      ],
      "equipment": "Barbell",
      "target_muscles": "Shoulders, Triceps"
    },
    {
      "title": "Lateral Raise",
      "image": "assets/img/dumbbell-lateral-raise.png",
      "detail_images": ["assets/img/dumbbell-lateral-raise.png"],
      "description_steps": [
        " Stand with your feet shoulder-width apart and hold a dumbbell in each hand",
        " Raise your arms to the sides until they are parallel to the ground",
        " Lower the dumbbells back to your sides and repeat"
      ],
      "equipment": "Dumbbells",
      "target_muscles": "Shoulders"
    },
    {
      "title": "Front Raise",
      "image": "assets/img/FrontRaises.png",
      "detail_images": ["assets/img/FrontRaises.png"],
      "description_steps": [
        " Stand with your feet shoulder-width apart and hold a dumbbell in each hand",
        " Raise the dumbbells in front of you until they are parallel to the ground",
        " Lower the dumbbells back to your sides and repeat"
      ],
      "equipment": "Dumbbells",
      "target_muscles": "Front Deltoids"
    },
    {
      "title": "Upright Row",
      "image": "assets/img/uprightrolls.png",
      "detail_images": ["assets/img/uprightrolls.png"],
      "description_steps": [
        " Stand with your feet shoulder-width apart and grip the barbell with your hands close together",
        " Pull the barbell up to your chin, keeping your elbows higher than your wrists",
        " Lower the barbell back to the starting position and repeat"
      ],
      "equipment": "Barbell",
      "target_muscles": "Shoulders, Traps"
    },
    {
      "title": "Face Pull",
      "image": "assets/img/cableface.png",
      "detail_images": ["assets/img/cableface.png"],
      "description_steps": [
        " Attach a rope to the high pulley of a cable station",
        " Stand facing the machine and grip the rope with both hands",
        " Pull the rope towards your face, keeping your elbows high",
        " Slowly return to the starting position and repeat"
      ],
      "equipment": "Cable Machine, Rope Attachment",
      "target_muscles": "Rear Deltoids, Upper Back"
    },
    {
      "title": "Crunch",
      "image": "assets/img/abCrunches.png",
      "detail_images": ["assets/img/abCrunches.png"],
      "description_steps": [
        " Lie on your back with your knees bent and feet flat on the floor",
        " Place your hands behind your head",
        " Lift your upper body towards your knees, squeezing your abs",
        " Lower back down and repeat"
      ],
      "equipment": "None",
      "target_muscles": "Abdominals"
    },
    {
      "title": "Plank",
      "image": "assets/img/Plank.png",
      "detail_images": ["assets/img/Plank.png"],
      "description_steps": [
        " Start in a push-up position with your forearms on the ground",
        " Keep your body in a straight line from head to heels",
        " Hold the position for the desired amount of time"
      ],
      "equipment": "None",
      "target_muscles": "Core"
    },
    {
      "title": "Leg Raise",
      "image": "assets/img/LegRaises.png",
      "detail_images": ["assets/img/LegRaises.png"],
      "description_steps": [
        " Lie on your back with your legs straight",
        " Lift your legs towards the ceiling, keeping them straight",
        " Lower your legs back down and repeat"
      ],
      "equipment": "None",
      "target_muscles": "Lower Abdominals"
    },
    {
      "title": "Russian Twist",
      "image": "assets/img/russiantwist.png",
      "detail_images": ["assets/img/russiantwist.png"],
      "description_steps": [
        " Sit on the floor with your knees bent and feet off the ground",
        " Hold a weight or medicine ball with both hands",
        " Twist your torso to the right, then to the left"
      ],
      "equipment": "Weight or Medicine Ball",
      "target_muscles": "Obliques"
    },
    {
      "title": "Mountain Climbers",
      "image": "assets/img/mountainClimber.png",
      "detail_images": ["assets/img/mountainClimber.png"],
      "description_steps": [
        " Start in a push-up position",
        " Bring one knee towards your chest and then switch legs quickly",
        " Continue alternating legs as fast as possible"
      ],
      "equipment": "None",
      "target_muscles": "Core, Shoulders"
    },
    {
      "title": "Squat",
      "image": "assets/img/squat.png",
      "detail_images": ["assets/img/squat.png"],
      "description_steps": [
        " Stand with your feet shoulder-width apart",
        " Lower your body by bending your knees and hips, keeping your back straight",
        " Push through your heels to return to the starting position"
      ],
      "equipment": "None",
      "target_muscles": "Quads, Glutes, Hamstrings"
    },
    {
      "title": "Lunges",
      "image": "assets/img/Lunges.png",
      "detail_images": ["assets/img/Lunges.png"],
      "description_steps": [
        " Stand with your feet together",
        " Step forward with one leg and lower your body until your back knee almost touches the ground",
        " Push through your front heel to return to the starting position and switch legs"
      ],
      "equipment": "None",
      "target_muscles": "Quads, Glutes, Hamstrings"
    },
    {
      "title": "Leg Press",
      "image": "assets/img/leg-press.png",
      "detail_images": ["assets/img/leg-press.png"],
      "description_steps": [
        " Sit on the leg press machine and place your feet on the platform",
        " Push the platform away from you until your legs are fully extended",
        " Lower the platform back down and repeat"
      ],
      "equipment": "Leg Press Machine",
      "target_muscles": "Quads, Glutes, Hamstrings"
    },
    {
      "title": "Romanian Deadlift",
      "image": "assets/img/romanian-deadlift.png",
      "detail_images": ["assets/img/romanian-deadlift.png"],
      "description_steps": [
        " Stand with feet hip-width apart and hold a barbell in front of thighs",
        " Hinge at hips and lower the barbell down legs",
        " Maintain a slight bend in knees, return to starting position by engaging glutes and hamstrings"
      ],
      "equipment": "Barbell",
      "target_muscles": "Hamstrings, Glutes"
    },
    {
      "title": "Calf Raise",
      "image": "assets/img/calf-raise.png",
      "detail_images": ["assets/img/calf-raise.png"],
      "description_steps": [
        " Stand with feet hip-width apart, holding onto a stable surface for balance",
        " Raise heels to stand on toes, pause briefly at the top",
        " Lower heels back to starting position"
      ],
      "equipment": "None",
      "target_muscles": "Calves"
    },
    {
      "title": "Wrist Curls",
      "image": "assets/img/WristCurl.png",
      "detail_images": ["assets/img/WristCurl.png"],
      "description_steps": [
        " Sit and rest forearms on thighs, palms facing up, hold a dumbbell in each hand",
        " Curl wrists upwards, keeping forearms stationary",
        " Lower wrists back to starting position"
      ],
      "equipment": "Dumbbells",
      "target_muscles": "Forearms"
    },
    {
      "title": "Reverse Wrist Curls",
      "image": "assets/img/reversewristcurls.png",
      "detail_images": ["assets/img/reversewristcurls.png"],
      "description_steps": [
        " Sit and rest forearms on thighs, palms facing down, hold a dumbbell in each hand",
        " Curl wrists upwards, keeping forearms stationary",
        " Lower wrists back to starting position"
      ],
      "equipment": "Dumbbells",
      "target_muscles": "Forearms"
    },
    {
      "title": "Farmer's Walk",
      "image": "assets/img/farmerswalk.png",
      "detail_images": ["assets/img/farmerswalk.png"],
      "description_steps": [
        " Hold a heavy dumbbell in each hand, stand tall with shoulders back",
        " Walk forward for a set distance or time, maintaining good posture",
        " Turn around and walk back to starting position"
      ],
      "equipment": "Dumbbells",
      "target_muscles": "Forearms, Shoulders, Core"
    },
    {
      "title": "Plate Pinches",
      "image": "assets/img/plate-pinch.png",
      "detail_images": ["assets/img/plate-pinch.png"],
      "description_steps": [
        " Hold a weight plate in each hand, pinching them between your thumb and fingers",
        " Lift plates and hold for a set time, keeping arms extended",
        " Lower plates back to starting position"
      ],
      "equipment": "Weight Plates",
      "target_muscles": "Forearms"
    }

    // Add other exercises with similar structure
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate the sublist of exercises for the current muscle group
    int start = widget.muscleGroupIndex * 5;
    List filteredList;
    if (start >= listArr.length) {
      filteredList = [];
    } else {
      int end = start + 5;
      if (end > listArr.length) {
        end = listArr.length;
      }
      filteredList = listArr.sublist(start, end);
    }

    return Scaffold(
      appBar: AppBar(
        // App bar configuration
        backgroundColor: TColor.secondary,
        centerTitle: false,
        title: Text(
          widget.groupTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemCount: filteredList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          var obj = filteredList[index] as Map? ?? {};
          return ExercisesRow(
            obj: obj,
            onPressed: () {
              // Prepare exercise details for the detail screen
              List<String> descSteps = (obj["description_steps"] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList();
              List<String> detailImgs = (obj["detail_images"] as List<dynamic>)
                  .map((e) => e.toString())
                  .toList();

              // Navigate to the exercise detail screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WorkoutExercisesDetailScreen(
                    title: obj["title"]?.toString() ?? "Exercise",
                    descriptionSteps: descSteps,
                    equipment: obj["equipment"]?.toString() ?? "Not specified",
                    targetMuscles: obj["target_muscles"]?.toString() ?? "Not specified",
                    detailImages: detailImgs,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}