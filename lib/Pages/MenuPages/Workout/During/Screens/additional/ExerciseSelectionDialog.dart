import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../Controllers/ExercisesController.dart';
import '../../../../../../Managers/TrainingManager.dart';
import '../../../../../../database_classes/Exercise.dart';
import '../../../../../../database_classes/ExerciseWrapper.dart';
import '../../../../../../database_classes/Group.dart';

class ExerciseSelectionDialog extends StatelessWidget {
  final Groups group;

  const ExerciseSelectionDialog({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final exercisesManager = Provider.of<ExercisesManager>(context, listen: false);

    return FutureBuilder<List<Exercise>>(
      future: exercisesManager.exercises, // Fetching exercises asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Loading screen
        } else if (snapshot.hasError) {
          return Center(child: Text("Błąd ładowania ćwiczeń!"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Brak ćwiczeń do wyświetlenia."));
        }

        final exercises = snapshot.data!;

        return AlertDialog(
          title: Center(
            child: Text(
              "Dodaj ćwiczenie",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Title color
              ),
            ),
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Smaller padding on left and right
            height: 400, // Fixed height
            width: double.maxFinite, // Full width
            child: ListView.separated(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return GestureDetector(
                  onTap: () {
                    // Logic for adding exercise
                    TrainingManager.tManager.workoutController!.selectedWorkout.exercises.add(
                      exercise.application == 1
                          ? ExerciseWrapper.full(
                        exercise: exercise,
                        weights: [],
                        repetitions: [],
                        series: 0,
                      )
                          : ExerciseWrapper.basic(exercise: exercise, series: 0),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Image.asset(exercise.iconPath, width: 50, height: 50),
                        const SizedBox(width: 20), // Space between icon and text
                        Expanded(
                          child: Text(
                            exercise.name,
                            style: TextStyle(fontSize: 19, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10), // Increased space between items
            ),
          ),
        );
      },
    );
  }
}
