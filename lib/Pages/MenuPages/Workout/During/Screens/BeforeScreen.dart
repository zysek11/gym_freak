// Before
import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/Group.dart';
import '../WorkoutWidgets.dart';
class BeforeExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseNumber;
  final int series;

  const BeforeExerciseScreen({
    Key? key,
    required this.group,
    required this.exerciseNumber,
    required this.series,
  }) : super(key: key);

  @override
  _BeforeExerciseScreenState createState() => _BeforeExerciseScreenState();
}

class _BeforeExerciseScreenState extends State<BeforeExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.group.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Jaapokki',
                        ),
                      ),
                      Image.asset(
                        widget.group.iconPath,
                      ),
                    ],
                  ),
                  Image.asset(
                    'assets/icons/exit.png',
                  ),
                ],
              ),
              Spacer(),
              Text(
                "EXERCISE ${(widget.exerciseNumber + 1).toString()}",
                style: TextStyle(
                  color: Color(0xFF2A8CBB),
                  fontSize: 45,
                  fontFamily: 'Jaapokki',
                ),
              ),
              SizedBox(height: 15),
              Text(
                widget.group.exercises[widget.exerciseNumber].name.toUpperCase(),
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black,
                  fontSize: 45,
                  fontFamily: 'Jaapokki',
                ),
              ),
              SizedBox(height: 15),
              Text(
                "SET: ${widget.series}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 45,
                  fontFamily: 'Jaapokki',
                ),
              ),
              Spacer(),
              TrainingButton(
                text: 'START A SERIES',
                onPressed: () {
                  TrainingManager.tManager.actualState = TrainingState.e_during;
                },
              ),
              SizedBox(height: 20),
              TrainingButton(
                text: widget.series == 1 ? 'SKIP EXERCISE': "EXERCISE DONE",
                onPressed: () {
                  if(widget.series != 1){
                    TrainingManager.tManager.sendWorkoutData(widget.group.exercises[widget.exerciseNumber]);
                  }
                  if (widget.group.exercises.length > widget.exerciseNumber + 1) {
                    TrainingManager.tManager.nextExercise();
                    TrainingManager.tManager.actualState = TrainingState.e_before;
                  } else {
                    TrainingManager.tManager.actualState = TrainingState.e_summary;
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
