import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../Controllers/ExercisesController.dart';
import '../../../../../../Managers/TrainingManager.dart';
import '../../../../../../database_classes/Exercise.dart';
import '../../../../../../database_classes/ExerciseWrapper.dart';

class ExerciseSelectionDialog extends StatefulWidget {
  final Iterable<int> exerciseIds;

  const ExerciseSelectionDialog({super.key, required this.exerciseIds});

  @override
  State<ExerciseSelectionDialog> createState() => _ExerciseSelectionDialogState();
}

class _ExerciseSelectionDialogState extends State<ExerciseSelectionDialog> {
  String searchQuery = ""; // To store the search query
  late Future<List<Exercise>> exercisesFuture; // Fetch exercises

  @override
  void initState() {
    super.initState();
    final exercisesManager = Provider.of<ExercisesManager>(context, listen: false);
    exercisesFuture = exercisesManager.exercises;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: exercisesFuture, // Fetching exercises asynchronously
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading screen
        } else if (snapshot.hasError) {
          return const Center(child: Text("Błąd ładowania ćwiczeń!"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Brak ćwiczeń do wyświetlenia."));
        }

        // Filter exercises based on the search query
        final exercises = snapshot.data!
            .where((exercise) =>
            exercise.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return AlertDialog(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              const Text(
                "Dodaj ćwiczenie",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2A8CBB), // Title color
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value; // Update search query
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Search exercises...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: Colors.blue, // Niebieski kolor obramowania
                            width: 2,          // Grubość obramowania
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: const Color(0xFF2A8CBB), // Niebieski kolor obramowania
                            width: 2,          // Grubość obramowania
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Smaller padding on left and right
            height: 400, // Fixed height
            width: double.maxFinite, // Full width
            child: exercises.isEmpty
                ? const Center(
              child: Text(
                "No matching exercises found.",
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.separated(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final isAlreadyAdded = widget.exerciseIds.contains(exercise.id);

                return GestureDetector(
                  onTap: () {
                    if (isAlreadyAdded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${exercise.name} is already added.",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    // Logic for adding exercise
                    TrainingManager.tManager.workoutController!
                        .selectedWorkout.exercises
                        .add(
                      ExerciseWrapper.full(
                        exercise: exercise,
                        weights: [],
                        repetitions: [],
                        series: 1,
                        date: TrainingManager.tManager.workoutController!
                            .selectedWorkout.date
                      ),
                    );
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isAlreadyAdded ? Colors.grey[300] : Colors.white,
                    ),
                    child: Row(
                      children: [
                        Image.asset(exercise.iconPath, width: 50, height: 50),
                        const SizedBox(width: 20), // Space between icon and text
                        Expanded(
                          child: Text(
                            exercise.name,
                            style: TextStyle(
                              fontSize: 19,
                              color: isAlreadyAdded ? Colors.grey : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) =>
              const SizedBox(height: 10), // Increased space between items
            ),
          ),
        );
      },
    );
  }
}
