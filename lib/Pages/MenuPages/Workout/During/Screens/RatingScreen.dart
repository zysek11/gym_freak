import 'package:flutter/material.dart';

class RatingExercisesScreen extends StatefulWidget {
  const RatingExercisesScreen({Key? key}) : super(key: key);

  @override
  _RatingExercisesScreenState createState() => _RatingExercisesScreenState();
}

class _RatingExercisesScreenState extends State<RatingExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Text(
            "Rating w",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
