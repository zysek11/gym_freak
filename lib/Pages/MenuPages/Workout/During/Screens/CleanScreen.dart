import 'package:flutter/material.dart';

class CleanExercisesScreen extends StatefulWidget {
  const CleanExercisesScreen({Key? key}) : super(key: key);

  @override
  _CleanExercisesScreenState createState() => _CleanExercisesScreenState();
}

class _CleanExercisesScreenState extends State<CleanExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Text(
            "Clean w",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
