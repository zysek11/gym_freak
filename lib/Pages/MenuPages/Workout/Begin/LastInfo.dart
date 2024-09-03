import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/During/WorkoutWidgets.dart';

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
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  WorkoutWidgets(pg: widget.pg,type: widget.type)),
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
