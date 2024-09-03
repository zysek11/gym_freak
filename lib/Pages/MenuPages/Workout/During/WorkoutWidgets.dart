import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_freak/Controllers/WorkoutController.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../database_classes/Group.dart';
import '../../../../database_classes/Workout.dart';

class WorkoutWidgets extends StatefulWidget {
  final Groups pg;
  final bool type;
  const WorkoutWidgets({super.key,  required this.pg,  required this.type});

  @override
  State<WorkoutWidgets> createState() => _WorkoutWidgetsState();
}

class _WorkoutWidgetsState extends State<WorkoutWidgets> {


  @override
  void initState() {
    TrainingManager.tManager.actualState = widget.type ? TrainingState.e_before : TrainingState.clean;
    TrainingManager.tManager.setOrResetData(widget.pg);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TrainingState>(
      stream: TrainingManager.tManager.stateStream, // Zakładam, że masz strumień aktualizujący stan
      initialData: TrainingManager.tManager.actualState,
      builder: (context, snapshot) {
        return TrainingManager.tManager.workoutController.loadWindow(snapshot.data!)!;
      },
    );
  }
}

class WidgetController {

  // Deklaracja właściwości `actualWindow` jako `Widget?`, aby mogła przyjąć wartość `null` początkowo.
  Widget? actualWindow;

  void setActualWindow(Widget newWindow) {
    actualWindow = newWindow;
  }

  // Przykładowa metoda do pobierania aktualnego widżetu
  Widget? getActualWindow() {
    return actualWindow;
  }

  Widget buildTrainingButton({
    required String text,
    required String command,
    required Groups group,
    required int en,
    IconData? icon,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF2A8CBB),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        onPressed: () {
          // kod dla e_during
          if(command == "start"){
            TrainingManager.tManager.actualState = TrainingState.e_during;
          }
          else if(command == "skip"){
            if(group.exercises.length > en + 1){
              TrainingManager.tManager.nextExercise();
              TrainingManager.tManager.actualState = TrainingState.e_before;
            }
            else {
              TrainingManager.tManager.actualState = TrainingState.e_summary;
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.black),
              if (icon != null) SizedBox(width: 10), // Dodaj odstęp jeśli jest ikona
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'Jaapokki',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget cleanExercises(){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Text("Clean w"),
        ),
      ),
    );
  }

  Widget beforeExercise(){
    int en = TrainingManager.tManager.exerciseNumber;
    int sn = TrainingManager.tManager.series;
    Groups group = TrainingManager.tManager.selectedGroup;

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
                        group.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontFamily: 'Jaapokki',
                          // button text color
                        ),
                      ),
                      Image.asset(
                        group.iconPath,
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
                "EXERCISE " +(en+1).toString(),
                style: TextStyle(
                  color: Color(0xFF2A8CBB),
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                  // button text color
                ),
              ),
              SizedBox(height: 15,),
              Text(
                group.exercises[en].name.toUpperCase(),
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black,
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                  // button text color
                ),
              ),
              SizedBox(height: 15,),
              Text(
                "SET: " + sn.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                  // button text color
                ),
              ),
              Spacer(),
              buildTrainingButton(text: 'START A SERIES',command: "start",en: en, group: group),
              SizedBox(height: 20,),
              buildTrainingButton(text: 'SKIP EXERCISE',command: "skip",en: en, group: group),
            ],
          ),
        ),
      ),
    );
  }
  Widget duringExercise(){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Text("During w"),
        ),
      ),
    );
  }

  Widget afterExercise(){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Text("After w"),
        ),
      ),
    );
  }

  Widget summaryExercise(){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Text("Summary w"),
        ),
      ),
    );
  }

  Widget ratingExercises(){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Text("Rating w"),
        ),
      ),
    );
  }
}