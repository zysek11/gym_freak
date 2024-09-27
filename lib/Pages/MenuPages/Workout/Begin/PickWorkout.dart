import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Exercises/PickGroupGroups.dart';
import '../../../../database_classes/Exercise.dart';
import '../../Exercises/AddGroup.dart';
import '../../Exercises/PickGroupExercises.dart';

class PickWorkout extends StatefulWidget {
  const PickWorkout({super.key});

  @override
  State<PickWorkout> createState() => _PickWorkoutState();
}

class _PickWorkoutState extends State<PickWorkout> {
  Widget _buildNavigationButton(BuildContext context, String text,
      String description, String imagePath, Function onTap) {
    return SizedBox(
      width: double.infinity,
      height: 300, // Ustawienie wysokości na 350
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF2A8CBB),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        onPressed: () => onTap(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  text.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontFamily: 'Jaapokki',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Opis po lewej stronie
                  Expanded(
                    flex: 2,
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8.0,top: 8),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            description,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Lato',
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )),
                  ),
                  // Obrazek po prawej stronie
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      imagePath,
                      height: 225,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A8CBB),
      body: SafeArea(
        child: SingleChildScrollView(
          // Zmieniamy na przewijalny widok
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            child: Column(
              children: [
                Text(
                  "PICK WORKOUT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Jaapokki',
                  ),
                ),
                SizedBox(height: 20),
                _buildNavigationButton(
                  context,
                  "Pick or combine groups",
                  "Pick one group or combine exercises from all of the groups.\n"
                      " You can use them as one workout.\n",
                  "assets/screens/screen1.png",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PickGroupGroups()), // Pierwsza klasa przekierowująca
                    );
                  },
                ),
                SizedBox(height: 15),
                _buildNavigationButton(
                  context,
                  "Select exercises",
                  "Pick specific exercises to build your workout. "
                      "Doesn't matter if they belong to any group.",
                  "assets/screens/screen2.png",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PickGroupExercises(
                              oneTimeW: true)), // Druga klasa przekierowująca
                    );
                  },
                ),
                SizedBox(height: 15),
                _buildNavigationButton(
                  context,
                  "Create a new group",
                  "Builds a new group of exercises for now and future workouts.\n"
                      "Then you need to pick it.",
                  "assets/screens/screen3.png",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddGroup(
                              edit: false)), // Trzecia klasa przekierowująca
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
