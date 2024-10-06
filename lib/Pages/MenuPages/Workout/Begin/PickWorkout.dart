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
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  text.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Jaapokki',
                  ),
                ),
              ),
            ),
            // Opis tekstu
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  description,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,
                    fontFamily: 'Lato',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Image.asset(
                imagePath,
                height: 54, // Możesz dostosować wysokość obrazka
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15,),
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max, // Maksymalny rozmiar kolumny
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "PICK WORKOUT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                ),
              ),
              _buildNavigationButton(
                context,
                "Pick or combine groups",
                "Pick one group or combine exercises from all of the groups."
                    " You can use them as one workout.",
                "assets/screens/screen1s.png",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PickGroupGroups()), // Pierwsza klasa przekierowująca
                  );
                },
              ),
              _buildNavigationButton(
                context,
                "Select exercises",
                "Pick specific exercises to build your workout. "
                    "Doesn't matter if they belong to any group.",
                "assets/screens/screen2s.png",
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PickGroupExercises(
                            oneTimeW: true)), // Druga klasa przekierowująca
                  );
                },
              ),
              _buildNavigationButton(
                context,
                "Create a new group",
                "Builds a new group of exercises for now and future workouts."
                    "Then you need to pick it.",
                "assets/screens/screen3s.png",
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
    );
  }

}
