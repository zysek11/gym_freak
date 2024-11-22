import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import 'package:lottie/lottie.dart';
import '../../../../../database_classes/Group.dart';
import '../../../../../database_classes/Exercise.dart';
import '../../../Exercises/PickGroupExercises.dart';
import '../WorkoutWidgets.dart';
import 'BeforeScreen.dart';
import 'CardComponent.dart';
import 'SummaryScreen.dart';

class PickExerciseScreen extends StatefulWidget {
  final Groups group;
  final List<int> asList;
  final int series;
  final bool full;

  const PickExerciseScreen({
    super.key,
    required this.group,
    required this.asList,
    required this.series,
    required this.full
  });

  @override
  State<PickExerciseScreen> createState() => _PickExerciseScreenState();
}

class _PickExerciseScreenState extends State<PickExerciseScreen> {

  late Groups workoutGroup;
  late List<int> workoutAsList;
  late int workoutSeries;
  late bool workoutFull;

  void refreshWorkout(List<Exercise> mod_exercises) {
    // Convert workoutGroup.exercises and mod_exercises to sets of IDs
    final workoutExerciseIds = workoutGroup.exercises.map((e) => e.id).toSet();
    final modExerciseIds = mod_exercises.map((e) => e.id).toSet();

    // Find IDs to remove
    final idsToRemove = workoutExerciseIds.difference(modExerciseIds);
    final idsToAdd = modExerciseIds.difference(workoutExerciseIds);

    // Remove exercises from workoutGroup that are not in mod_exercises
    workoutGroup.exercises.removeWhere((exercise) => idsToRemove.contains(exercise.id));

    // Add exercises from mod_exercises that are not in workoutGroup
    workoutGroup.exercises.addAll(
      mod_exercises.where((exercise) => idsToAdd.contains(exercise.id)),
    );
    for (var id in idsToRemove) {
      print(idsToRemove);
      TrainingManager.tManager.redoWorkoutData(id!);
    }
    // przypisanie do zmienny workout group itp tych danych z TrainingManagera
    // ewentualnie zrobic tu jakis consumer
    workoutAsList = TrainingManager.tManager.alreadySelected;
    workoutSeries = TrainingManager.tManager.series;
  }




  @override
  void initState() {
    workoutGroup = widget.group;
    workoutAsList = widget.asList;
    workoutSeries = widget.series;
    workoutFull = widget.full;
    super.initState();
  }

  Future<bool?> showExitTrainingDialog(BuildContext context, String text) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // Tło dialogu
        title: Center(
          child: Text(
            'Exit Training',
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
    return PopScope(
      canPop: false,
      onPopInvoked: ((didpop) async {
        if(didpop){
          return ;
        }
        final bool shouldpop = await showExitTrainingDialog(context,'Leaving '
            'this screen will cancel the training. Are you sure you want to exit?') ?? false;
        if(context.mounted && shouldpop){
          Navigator.pop(context);
        }
      }), // Przechwytujemy akcję cofania
      child: Scaffold(
        backgroundColor: const Color(0xFF2A8CBB),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 10, left: 25, right: 25),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 10),
                workoutFull ? const TimerCardComponent(bgColor: Color(0xffffffff),breakActive: true, duringActive: false,)
                  : const TimerCardComponent(bgColor: Color(0xffffffff),breakActive: false, duringActive: false,),
                const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF2A8CBB),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      Iterable<int> exerciseIds = workoutGroup.exercises.map((exercise) => exercise.id!).toList();
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PickGroupExercises(oneTimeW: false,editables: exerciseIds,)), // AddExercisePage to strona dodawania ćwiczenia
                      );
                      if (result != null) {
                        setState(() {
                          refreshWorkout(result);
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "Modify exercises",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontFamily: 'Jaapokki',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
                const SizedBox(height: 20),
                if(workoutFull)
                  Expanded(
                  child: Center(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: workoutGroup.exercises.length,
                      itemBuilder: (context, index) {
                        Exercise exercise = workoutGroup.exercises[index];
                        bool isDisabled = workoutAsList.contains(exercise.id);

                        return GestureDetector(
                          onTap: isDisabled
                              ? null
                              : () {
                            TrainingManager.tManager.setExercise(exercise.id!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BeforeExerciseScreen(
                                  group: TrainingManager.tManager.selectedGroup,
                                  exerciseId: TrainingManager.tManager.exerciseIdSelect,
                                  exerciseNumber: TrainingManager.tManager.exerciseNumber,
                                  series: TrainingManager.tManager.series,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDisabled ? Colors.grey.shade400 : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFF2A8CBB),
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    exercise.name,
                                    style: TextStyle(
                                      fontSize: 21,
                                      color: isDisabled ? Colors.grey.shade700 : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Image.asset(exercise.iconPath),
                                  const Spacer(),
                                  Text(
                                    exercise.type,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isDisabled ? Colors.grey.shade700 : Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
                else ...[
                  Spacer(),
                  Text(
                    textAlign: TextAlign.center,
                    "WORKOUT\nIN PROGRESS!\nSTAY STRONG!",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Jaapokki',
                        height: 2
                    ),
                  ),
                  Spacer(),
                  Lottie.asset(
                    'assets/animations/workout_in_progress.json', // Ścieżka do lokalnego pliku JSON
                    width: 250,
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                  Spacer()
                ],
                const SizedBox(height: 20),
                workoutFull ? TrainingButton(
                  text: TrainingManager.tManager.workoutController!.selectedWorkout.exercises.isNotEmpty ? 'FINISH': "CANCEL",
                  onPressed: () async {
                    if(TrainingManager.tManager.workoutController!.selectedWorkout.exercises.isNotEmpty){
                      final bool shouldpop = await showExitTrainingDialog(context,
                          'Leaving this screen will finish this training. '
                              'Are you sure you want to exit?') ?? false;
                      if(context.mounted && shouldpop){

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const SummaryExerciseScreen(),),
                              (Route<dynamic> route) => route.isFirst,
                        );
                      }
                    }
                    else{
                      final bool shouldpop = await showExitTrainingDialog(context,
                          'Leaving this screen will cancel the training. '
                              'Are you sure you want to exit?') ?? false;
                      if(context.mounted && shouldpop){
                        Navigator.pop(context);
                      }
                    }
                  },
                ) :
                TrainingButton(
                  text: "WORKOUT DONE",
                  onPressed: () async {
                      final bool shouldpop = await showExitTrainingDialog(context,
                          'Leaving this screen will finish this training. '
                              'Are you sure you want to exit?') ?? false;
                      if(context.mounted && shouldpop){
                        TrainingManager.tManager.short_assignForSummary();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const SummaryExerciseScreen(),),
                              (Route<dynamic> route) => route.isFirst,
                        );
                      }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
