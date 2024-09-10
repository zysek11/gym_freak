import 'package:flutter/material.dart';

class SummaryExerciseScreen extends StatefulWidget {
  const SummaryExerciseScreen({Key? key}) : super(key: key);

  @override
  _SummaryExerciseScreenState createState() => _SummaryExerciseScreenState();
}

class _SummaryExerciseScreenState extends State<SummaryExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Text(
            "Summary w",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
