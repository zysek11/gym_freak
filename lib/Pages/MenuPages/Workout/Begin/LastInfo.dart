import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/During/Screens/PickExerciseScreen.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/During/WorkoutWidgets.dart';

import '../../../../Managers/TrainingManager.dart';
import '../../../../database_classes/Group.dart';

class LastInfo extends StatefulWidget {
  final Groups pg;
  final bool type;
  const LastInfo({super.key,  required this.pg,  required this.type});

  @override
  State<LastInfo> createState() => _LastInfoState();
}

class _LastInfoState extends State<LastInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A8CBB),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30, bottom: 10,left: 25, right: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "NOW DESTROY\nSOME DUMBBELLS!\nGOOD LUCK!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                  height: 1.75
                  // button text color
                ),
              ),
              Spacer(),
              Image.asset(
                'assets/gymmy/7th.png',
                fit: BoxFit.cover,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF2A8CBB),
                    backgroundColor: Colors.white,
                    // button text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      // button border radius
                      side: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  onPressed: () {
                    TrainingManager.tManager.setOrResetData(widget.pg);
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
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'START! ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'Jaapokki',
                        // button text color
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
