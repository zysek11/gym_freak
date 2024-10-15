// During
import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/Group.dart';
import '../WorkoutWidgets.dart';
import 'AfterScreen.dart';
import 'BeforeScreen.dart';
import 'CardComponent.dart';

class DuringExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseIndex;
  final int exerciseNumber;
  final int series;

  const DuringExerciseScreen({
    Key? key,
    required this.group,
    required this.exerciseIndex,
    required this.exerciseNumber,
    required this.series,
  }) : super(key: key);

  @override
  _DuringExerciseScreenState createState() => _DuringExerciseScreenState();
}

class _DuringExerciseScreenState extends State<DuringExerciseScreen> {

  @override
  void initState() {
    if(TrainingManager.tManager.breakTimerOn){
      TrainingManager.tManager.stopBreakTimer();
    }
    TrainingManager.tManager.startTimer();
    super.initState();
  }

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
              const TimerCardComponent(bgColor: Color(0xffffffff),breakActive: false, duringActive: true,),
              SizedBox(height: 100,),
              Text(
                "EXERCISE ${(widget.exerciseNumber + 1).toString()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                ),
              ),
              SizedBox(height: 25),
              Text(
                widget.group.exercises[widget.exerciseNumber].name,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                ),
              ),
              SizedBox(height: 25),
              Text(
                "SET: ${widget.series}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                ),
              ),
              Spacer(),
              TrainingButton(
                text: 'FINISHED!',
                onPressed: () {
                  TrainingManager.tManager.stopTimer();
                  if(widget.group.exercises[widget.exerciseNumber].application == 1)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AfterExerciseScreen(
                            group: TrainingManager.tManager.selectedGroup,
                            exerciseIndex: TrainingManager.tManager.exerciseIdSelect,
                            exerciseNumber: TrainingManager.tManager.exerciseNumber,
                            series: TrainingManager.tManager.series,
                          ),
                        ),
                      );
                    }
                  else{
                    TrainingManager.tManager.nextSeries();
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
