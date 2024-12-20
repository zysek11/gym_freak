import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/Exercise.dart';
import '../../../../../database_classes/Group.dart';
import '../WorkoutWidgets.dart';
import 'AfterScreen.dart';
import 'BeforeScreen.dart';
import 'CardComponent.dart';

class DuringExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseId;
  final int exerciseNumber;
  final int series;

  const DuringExerciseScreen({
    Key? key,
    required this.group,
    required this.exerciseId,
    required this.exerciseNumber,
    required this.series,
  }) : super(key: key);

  @override
  _DuringExerciseScreenState createState() => _DuringExerciseScreenState();
}

class _DuringExerciseScreenState extends State<DuringExerciseScreen> {
  late Exercise? currentExercise;

  @override
  void initState() {
    // Find the exercise by ID
    currentExercise = widget.group.exercises
        .firstWhere((exercise) => exercise.id == widget.exerciseId);

    if (TrainingManager.tManager.breakTimerOn) {
      TrainingManager.tManager.stopBreakTimer();
    }
    TrainingManager.tManager.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (currentExercise == null) {
      // Handle case where the exercise is not found
      return Scaffold(
        backgroundColor: Color(0xFF2A8CBB),
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

    return Scaffold(
      backgroundColor: Color(0xFF2A8CBB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const TimerCardComponent(
                bgColor: Color(0xffffffff),
                breakActive: false,
                duringActive: true,
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
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'Jaapokki',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Container(width: 4,color: Colors.white, height: 30,),
                  ),
                  Text(
                    "SET ${widget.series}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'Jaapokki',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                currentExercise!.name,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
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
              SizedBox(height: 10,),
              Spacer(),
              TrainingButton(
                text: 'FINISHED!',
                onPressed: () {
                  TrainingManager.tManager.stopTimer();
                  if (currentExercise!.application == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AfterExerciseScreen(
                          group: TrainingManager.tManager.selectedGroup,
                          exerciseId: TrainingManager.tManager.exerciseIdSelect,
                          exerciseNumber: TrainingManager.tManager.exerciseNumber,
                          series: TrainingManager.tManager.series,
                        ),
                      ),
                    );
                  } else {
                    TrainingManager.tManager.nextSeries();
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
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
