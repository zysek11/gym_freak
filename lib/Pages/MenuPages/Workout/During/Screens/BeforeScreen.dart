// Before
import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/Group.dart';
import '../WorkoutWidgets.dart';
import 'DuringScreen.dart';
import 'PickExerciseScreen.dart';
import 'SummaryScreen.dart';

class BeforeExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseIndex;
  final int exerciseNumber;
  final int series;

  const BeforeExerciseScreen({
    Key? key,
    required this.group,
    required this.exerciseIndex,
    required this.exerciseNumber,
    required this.series,
  }) : super(key: key);

  @override
  _BeforeExerciseScreenState createState() => _BeforeExerciseScreenState();
}

class _BeforeExerciseScreenState extends State<BeforeExerciseScreen> {

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop){
        TrainingManager.tManager.checkUndoSeries();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  "EXERCISE ${(widget.exerciseNumber + 1).toString()}",
                  style: TextStyle(
                    color: Color(0xFF2A8CBB),
                    fontSize: 40,
                    fontFamily: 'Jaapokki',
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  widget.group.exercises[widget.exerciseIndex].name,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'Jaapokki',
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "SET: ${widget.series}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontFamily: 'Jaapokki',
                  ),
                ),
                Spacer(),
                TrainingButton(
                  text: 'START A SERIES',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DuringExerciseScreen(
                          group: TrainingManager.tManager.selectedGroup,
                          exerciseIndex: TrainingManager.tManager.exerciseIdSelect,
                          exerciseNumber: TrainingManager.tManager.exerciseNumber,
                          series: TrainingManager.tManager.series,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                TrainingButton(
                  text: widget.series == 1 ? 'SKIP EXERCISE': "EXERCISE DONE",
                  onPressed: () {
                    if(widget.series == 1){
                      TrainingManager.tManager.sendSkipData();
                    }
                    else if(widget.series != 1){
                      TrainingManager.tManager.sendWorkoutData(widget.group.exercises[widget.exerciseIndex]);
                    }
                    if (widget.group.exercises.length > widget.exerciseNumber + 1) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PickExerciseScreen(
                                group: TrainingManager.tManager.selectedGroup,
                                exerciseNumber: TrainingManager.tManager.exerciseNumber,
                                asList: TrainingManager.tManager.alreadySelected,
                                series: TrainingManager.tManager.series,
                              ),),
                            (Route<dynamic> route) => route.isFirst,
                      );
                    } else {
                      if(TrainingManager.tManager.workoutController.selectedWorkout.exercises.isNotEmpty){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const SummaryExerciseScreen(),),
                              (Route<dynamic> route) => route.isFirst,
                        );
                      }
                      else {
                        Navigator.popUntil(context, (route) => route.isFirst);
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
