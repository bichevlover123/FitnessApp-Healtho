import 'package:flutter/material.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_cell.dart';
import 'package:healtho_gym/screen/home/top_tab_view/exercises/exercises_name_screen.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final List listArr = [
    {
      "title": "Chest",
      "subtitle": "5 Exercises",
      "image": "assets/img/ex_1.png"
    },
    {
      "title": "Back",
      "subtitle": "5 Exercises",
      "image": "assets/img/ex_2.png"
    },
    {
      "title": "Biceps",
      "subtitle": "5 Exercises",
      "image": "assets/img/ex_3.png"
    },
    {
      "title": "Triceps",
      "subtitle": "5 Exercises",
      "image": "assets/img/ex_4.png"
    },
    {
      "title": "Shoulders",
      "subtitle": "5 Exercises",
      "image": "assets/img/ex_5.png"
    },
    {
      "title": "Abs",
      "subtitle": "5 Exercises",
      "image": "assets/img/ex_6.png"
    },
    {
      "title": "Legs",
      "subtitle": "5 Exercises",
      "image": "assets/img/ex_7.png"
    },
    {
      "title": "Forearms",
      "subtitle": "4 Exercises",
      "image": "assets/img/ex_8.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        thumbVisibility: true,
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15),
          itemCount: listArr.length,
          itemBuilder: (context, index) {
            final Map obj = listArr[index];
            return ExercisesCell(
              obj: obj,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExercisesNameScreen(
                      muscleGroupIndex: index,
                      groupTitle: obj["title"],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
