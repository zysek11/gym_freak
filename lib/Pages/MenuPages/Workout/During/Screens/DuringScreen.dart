// During
import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/Group.dart';
import '../WorkoutWidgets.dart';

class DuringExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseNumber;
  final int series;

  const DuringExerciseScreen({
    Key? key,
    required this.group,
    required this.exerciseNumber,
    required this.series,
  }) : super(key: key);

  @override
  _DuringExerciseScreenState createState() => _DuringExerciseScreenState();
}

class _DuringExerciseScreenState extends State<DuringExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A8CBB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.group.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Jaapokki',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  widget.group.iconPath,
                ),
              ),
              Spacer(),
              Text(
                widget.group.exercises[widget.exerciseNumber].name.toUpperCase(),
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 45,
                  fontFamily: 'Jaapokki',
                ),
              ),
              SizedBox(height: 15),
              Text(
                "SET: ${widget.series}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontFamily: 'Jaapokki',
                ),
              ),
              SizedBox(height: 100),
              StreamBuilder<int>(
                stream: TrainingManager.tManager.timeStream,
                initialData: 0,
                builder: (context, snapshot) {
                  final elapsedTime = snapshot.data ?? 0;
                  final minutes = (elapsedTime ~/ 60).toString().padLeft(2, '0');
                  final seconds = (elapsedTime % 60).toString().padLeft(2, '0');
                  return Text(
                    "$minutes:$seconds",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 70,
                      fontFamily: 'Jaapokki',
                    ),
                  );
                },
              ),
              Spacer(),
              TrainingButton(
                text: 'FINISHED!',
                onPressed: () {
                  if(widget.group.exercises[widget.exerciseNumber].application == 1)
                    {
                      TrainingManager.tManager.actualState = TrainingState.e_after;
                    }
                  else{
                    TrainingManager.tManager.nextSeries();
                    TrainingManager.tManager.actualState = TrainingState.e_before;
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
