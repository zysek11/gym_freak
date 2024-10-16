import 'package:flutter/material.dart';
import 'package:gym_freak/Controllers/ExercisesController.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/During/Screens/RatingScreen.dart';
import 'package:gym_freak/database_classes/Workout.dart';
import 'package:gym_freak/database_classes/ExerciseWrapper.dart';

import '../WorkoutWidgets.dart';
import 'additional/ExerciseSelectionDialog.dart';

class SummaryExerciseScreen extends StatefulWidget {
  const SummaryExerciseScreen({Key? key}) : super(key: key);

  @override
  _SummaryExerciseScreenState createState() => _SummaryExerciseScreenState();
}

class _SummaryExerciseScreenState extends State<SummaryExerciseScreen> {
  late Workout workout;

  @override
  void initState() {
    super.initState();
    TrainingManager.tManager.dispose();
    workout = TrainingManager.tManager.workoutController!.selectedWorkout;
  }

  void removeSet(ExerciseWrapper exercise, int setIndex) {
    setState(() {
      exercise.weights?.removeAt(setIndex);
      exercise.repetitions?.removeAt(setIndex);
    });
  }

  void editSet(ExerciseWrapper exercise, int setIndex, double newWeight, int newReps) {
    setState(() {
      exercise.weights?[setIndex] = newWeight;
      exercise.repetitions?[setIndex] = newReps;
    });
  }

  void addSet(ExerciseWrapper exercise) {
    setState(() {
      exercise.weights?.add(0); // Dodajemy nową wagę (domyślnie 0 kg)
      exercise.repetitions?.add(0); // Dodajemy nową liczbę powtórzeń (domyślnie 0 powtórzeń)
    });

    // Po dodaniu seta od razu pokazujemy dialog do edycji
    _editSetDialog(exercise, exercise.weights!.length - 1);
  }

  void removeExercise(int id){
    workout.exercises.removeAt(id);
  }

  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ExerciseSelectionDialog(group: TrainingManager.tManager.selectedGroup);
      },
    ).then((_) {
      setState(() {}); // Refresh the screen after adding an exercise
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A8CBB), // Niebieskie tło
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'SUMMARY',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Biały tekst
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: workout.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = workout.exercises[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(exercise.exercise.iconPath, width: 50, height: 50),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    exercise.exercise.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      removeExercise(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: exercise.weights!.length,
                              separatorBuilder: (context, index) => const Divider(
                                color: Colors.black, // Kolor separatora
                                thickness: 1, // Grubość separatora
                                indent: 25,
                                endIndent: 25,
                              ),
                              itemBuilder: (context, setIndex) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  margin: const EdgeInsets.symmetric(vertical: 5), // Odstęp pomiędzy elementami
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround, // Elementy w równych odstępach
                                    children: [
                                      // Informacje o serii
                                      Text(
                                        "Set ${setIndex + 1}:",
                                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${exercise.weights?[setIndex]} kg x ${exercise.repetitions?[setIndex]} reps",
                                        style: const TextStyle(fontSize: 19),
                                      ),
                                      // Ikony edycji i usuwania
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () {
                                              _editSetDialog(exercise, setIndex);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              removeSet(exercise, setIndex);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },

                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  addSet(exercise); // Natychmiast po dodaniu otwieramy dialog
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Set',style: TextStyle(fontSize: 19),),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFF2A8CBB),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10,),
              TrainingButton(
                  text: 'Add missing exercises',
                  onPressed: _showAddExerciseDialog
              ),
              SizedBox(height: 10,),
              TrainingButton(
                text: 'NEXT',
                onPressed: () {
                  if(workout.exercises.any((exercise) => exercise.series == 0)){
                    const snackBar = SnackBar(
                      content: Text(
                        'Do not leave empty exercises ;)',
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color(0xFFFFFFFF),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingExercisesScreen(
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editSetDialog(ExerciseWrapper exercise, int setIndex) async {
    TextEditingController weightController = TextEditingController(text: exercise.weights?[setIndex].toString());
    TextEditingController repsController = TextEditingController(text: exercise.repetitions?[setIndex].toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Set'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: repsController,
                decoration: const InputDecoration(labelText: 'Repetitions'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? newWeight = double.tryParse(weightController.text);
                int? newReps = int.tryParse(repsController.text);
                if (newWeight != null && newReps != null) {
                  editSet(exercise, setIndex, newWeight, newReps);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
