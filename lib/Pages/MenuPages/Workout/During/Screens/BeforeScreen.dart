import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/Exercise.dart';
import '../../../../../database_classes/Group.dart';
import '../WorkoutWidgets.dart';
import 'CardComponent.dart';
import 'DuringScreen.dart';
import 'PickExerciseScreen.dart';
import 'SummaryScreen.dart';

class BeforeExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseId;
  final int exerciseNumber;
  final int series;

  const BeforeExerciseScreen({
    Key? key,
    required this.group,
    required this.exerciseId,
    required this.exerciseNumber,
    required this.series,
  }) : super(key: key);

  @override
  _BeforeExerciseScreenState createState() => _BeforeExerciseScreenState();
}

class _BeforeExerciseScreenState extends State<BeforeExerciseScreen> {
  late Exercise? currentExercise;

  @override
  void initState() {
    super.initState();
    // Find the exercise by ID
    currentExercise = widget.group.exercises
        .firstWhere((exercise) => exercise.id == widget.exerciseId);
  }

  @override
  Widget build(BuildContext context) {
    if (currentExercise == null) {
      // Handle case where the exercise is not found
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Text(
              'Exercise not found!',
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
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
                const TimerCardComponent(
                  bgColor: Color(0xffffffff),
                  breakActive: true,
                  duringActive: false,
                ),
                Spacer(),
                SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "EXERCISE ${(widget.exerciseNumber + 1).toString()}",
                      style: TextStyle(
                        color: Color(0xFF2A8CBB),
                        fontSize: 35,
                        fontFamily: 'Jaapokki',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Container(width: 4,color: Colors.black, height: 30,),
                    ),
                    Text(
                      "SET ${widget.series}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontFamily: 'Jaapokki',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  currentExercise!.name,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Jaapokki',
                  ),
                ),
                SizedBox(height: 20),
                if(currentExercise!.imagePath != '')
                    Image.file(
                      File(currentExercise!.imagePath),
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                SizedBox(height: 10),
                Spacer(),
                TrainingButton(
                  text: 'START A SERIES',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DuringExerciseScreen(
                          group: TrainingManager.tManager.selectedGroup,
                          exerciseId: TrainingManager.tManager.exerciseIdSelect,
                          exerciseNumber: TrainingManager.tManager.exerciseNumber,
                          series: TrainingManager.tManager.series,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                TrainingButton(
                  text: widget.series == 1 ? 'SKIP EXERCISE' : "EXERCISE DONE",
                  onPressed: () {
                    if (widget.series == 1) {
                      TrainingManager.tManager.sendSkipData();
                    } else if (widget.series != 1) {
                      TrainingManager.tManager
                          .sendWorkoutData(currentExercise!);
                    }
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PickExerciseScreen(
                          group: TrainingManager.tManager.selectedGroup,
                          asList: TrainingManager.tManager.alreadySelected,
                          series: TrainingManager.tManager.series,
                          full: true,
                        ),
                      ),
                          (Route<dynamic> route) => route.isFirst,
                    );
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
