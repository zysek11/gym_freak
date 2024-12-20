import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../Managers/TrainingManager.dart';
import '../../../../../database_classes/Exercise.dart';
import '../../../../../database_classes/Group.dart';
import '../WorkoutWidgets.dart';
import 'BeforeScreen.dart';

class AfterExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseId;
  final int exerciseNumber;
  final int series;

  const AfterExerciseScreen({
    Key? key,
    required this.group,
    required this.exerciseId,
    required this.exerciseNumber,
    required this.series,
  }) : super(key: key);

  @override
  _AfterExerciseScreenState createState() => _AfterExerciseScreenState();
}

class _AfterExerciseScreenState extends State<AfterExerciseScreen> {
  TextEditingController tecWeights = TextEditingController();
  TextEditingController tecRepeats = TextEditingController();
  double weight = 0;
  int repeats = 0;
  late Exercise? currentExercise;

  void writeDataToWeight() {
    tecWeights.text = weight.toString();
  }

  void writeDataToRepeat() {
    tecRepeats.text = repeats.toString();
  }

  @override
  void initState() {
    // Find the exercise by ID
    currentExercise = widget.group.exercises
        .firstWhere((exercise) => exercise.id == widget.exerciseId);

    TrainingManager.tManager.stopTimer();
    if (TrainingManager.tManager.breakTimerOn) {
      TrainingManager.tManager.startBreakTimer();
    }
    writeDataToWeight();
    writeDataToRepeat();
    super.initState();
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
        TrainingManager.tManager.startTimer();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(),
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
                  currentExercise!.name.toUpperCase(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        "WEIGHT",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {
                            weight = double.tryParse(text) ?? 0;
                          });
                        },
                        controller: tecWeights,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove, size: 30),
                      onPressed: () {
                        setState(() {
                          if (weight > 0) {
                            weight--;
                            writeDataToWeight();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 30, color: Color(0xFF2A8CBB)),
                      onPressed: () {
                        setState(() {
                          weight++;
                          writeDataToWeight();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        "REPEATS",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          setState(() {
                            repeats = int.tryParse(text) ?? 0;
                          });
                        },
                        controller: tecRepeats,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove, size: 30),
                      onPressed: () {
                        setState(() {
                          if (repeats > 0) {
                            repeats--;
                            writeDataToRepeat();
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add, size: 30, color: Color(0xFF2A8CBB)),
                      onPressed: () {
                        setState(() {
                          repeats++;
                          writeDataToRepeat();
                        });
                      },
                    ),
                  ],
                ),
                Spacer(),
                TrainingButton(
                  text: 'NEXT',
                  onPressed: () {
                    if (tecRepeats.text.isNotEmpty && tecWeights.text.isNotEmpty) {
                      TrainingManager.tManager.addSetData(weight, repeats);
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
                    } else {
                      const snackBar = SnackBar(
                        content: Text(
                          'Fill weights and repeats first.',
                          style: TextStyle(color: Colors.black),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFFFFFFFF),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
