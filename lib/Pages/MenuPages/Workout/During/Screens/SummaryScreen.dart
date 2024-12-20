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

  Iterable<int> getExerciseIds(Workout workout) {
    // Assuming `workout` has a list of `ExerciseWrapper` objects, each containing an `Exercise`
    return workout.exercises
        .map((wrapper) => wrapper.exercise.id) // Extract the ID from each Exercise
        .whereType<int>(); // Filter out null IDs and keep only valid integers
  }
  
  void removeSet(ExerciseWrapper exercise, int setIndex) {
    setState(() {
      exercise.weights?.removeAt(setIndex);
      exercise.repetitions?.removeAt(setIndex);
      exercise.series -= 1;
    });
  }

  void editSet(ExerciseWrapper exercise, int setIndex, double newWeight, int newReps) {
    setState(() {
      exercise.weights?[setIndex] = newWeight;
      exercise.repetitions?[setIndex] = newReps;
    });
  }

  void addSet(ExerciseWrapper exercise) {
    if(exercise.exercise.application == 1){
      setState(() {
        exercise.weights?.add(0); // Dodajemy nową wagę (domyślnie 0 kg)
        exercise.repetitions?.add(0); // Dodajemy nową liczbę powtórzeń (domyślnie 0 powtórzeń)
        exercise.series += 1;
      });

      _editSetDialog(exercise, exercise.weights!.length - 1);
    }
    else{
      setState(() {
        exercise.series += 1;
      });
    }

    // Po dodaniu seta od razu pokazujemy dialog do edycji

  }

  void removeExercise(int id){
    workout.exercises.removeAt(id);
  }

  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ExerciseSelectionDialog(exerciseIds: getExerciseIds(workout),);
      },
    ).then((_) {
      setState(() {}); // Refresh the screen after adding an exercise
    });
  }

  Future<bool?> showDeleteExerciseDialog(BuildContext context, String text) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Tło dialogu
        title: Center(
          child: Text(
            'Delete exercise',
            style: TextStyle(
              color: Color(0xFF2A8CBB), // Kolor tekstu tytułu
              fontSize: 27, // Rozmiar czcionki tytułu
            ),
          ),
        ),
        content: Text(
          text,
          style: TextStyle(
            fontSize: 20, // Rozmiar czcionki tekstu
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Równomierne rozmieszczenie przycisków
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF2A8CBB), // Kolor tła przycisku
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Wewnętrzny padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Zaokrąglone rogi
                  ),
                ),
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.white, // Kolor tekstu przycisku
                    fontWeight: FontWeight.bold, // Pogrubienie tekstu
                    fontSize: 20,
                  ),
                ),
                onPressed: () => Navigator.pop(context, true), // Pozwól na wyjście
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white, // Bez tła, tylko tekst
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Wewnętrzny padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Zaokrąglone rogi
                  ),
                ),
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Color(0xFF2A8CBB), // Kolor tekstu przycisku
                    fontWeight: FontWeight.bold, // Pogrubienie tekstu
                    fontSize: 20,
                  ),
                ),
                onPressed: () => Navigator.pop(context, false), // Nie pozwól na wyjście
              ),
            ],
          ),
        ],
      ),
    );
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
                                    setState(() async {
                                      bool? decision = await showDeleteExerciseDialog(context, "Are you sure you want to delete this exercise?");
                                      if(decision != null  && decision == true ) removeExercise(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: exercise.series -1,
                            separatorBuilder: (context, index) => const Divider(
                              color: Colors.black, // Kolor separatora
                              thickness: 1, // Grubość separatora
                              indent: 10,
                              endIndent: 10,
                            ),
                            itemBuilder: (context, setIndex) {
                              if (exercise.exercise.application == 1) {
                                // Wyświetlanie danych o serii
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  margin: const EdgeInsets.symmetric(vertical: 3), // Odstęp pomiędzy elementami
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
                              } else {
                                // Wyświetlanie informacji o zakończeniu serii z możliwością usunięcia
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  margin: const EdgeInsets.symmetric(vertical: 3), // Odstęp pomiędzy elementami
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "Set ${setIndex + 1} finished.",
                                            style: TextStyle(fontSize: 18, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          removeSet(exercise, setIndex);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
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
                  text: 'ADD MISSING EXERCISES',
                  onPressed: _showAddExerciseDialog
              ),
              SizedBox(height: 10,),
              TrainingButton(
                text: 'NEXT',
                onPressed: () {
                  if(workout.exercises.any((exercise) => exercise.series == 1)){
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
