import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/Group.dart';
import '../../../../../database_classes/Exercise.dart';
import '../WorkoutWidgets.dart';
import 'BeforeScreen.dart';
import 'SummaryScreen.dart';

class PickExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseNumber;
  final List<int> asList;
  final int series;

  const PickExerciseScreen({
    super.key,
    required this.group,
    required this.exerciseNumber,
    required this.asList,
    required this.series,
  });

  @override
  State<PickExerciseScreen> createState() => _PickExerciseScreenState();
}

class _PickExerciseScreenState extends State<PickExerciseScreen> {
  @override
  void initState() {
    TrainingManager.tManager.startGlobalTimer();
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
                Text(
                  widget.group.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Jaapokki',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        widget.group.iconPath,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 30),
                      StreamBuilder<int>(
                        stream: TrainingManager.tManager.globalTimeStream,
                        initialData: 0,
                        builder: (context, snapshot) {
                          final elapsedTime = snapshot.data ?? 0;
                          final minutes = (elapsedTime ~/ 60).toString().padLeft(2, '0');
                          final seconds = (elapsedTime % 60).toString().padLeft(2, '0');
                          return Text(
                            "$minutes:$seconds",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Jaapokki',
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "PICK EXERCISE",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Jaapokki',
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: widget.group.exercises.length,
                      itemBuilder: (context, index) {
                        Exercise exercise = widget.group.exercises[index];
                        bool isDisabled = widget.asList.contains(index);

                        return GestureDetector(
                          onTap: isDisabled
                              ? null
                              : () {
                            TrainingManager.tManager.setExercise(index);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BeforeExerciseScreen(
                                  group: TrainingManager.tManager.selectedGroup,
                                  exerciseIndex: TrainingManager.tManager.exerciseIdSelect,
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
                ),
                const SizedBox(height: 20),
                TrainingButton(
                  text: TrainingManager.tManager.workoutController.selectedWorkout.exercises.isNotEmpty ? 'FINISH BEFORE': "CANCEL",
                  onPressed: () async {
                    if(TrainingManager.tManager.workoutController.selectedWorkout.exercises.isNotEmpty){
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
