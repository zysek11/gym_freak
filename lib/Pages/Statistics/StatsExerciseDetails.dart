import 'package:flutter/material.dart';

class StatsExerciseDetails extends StatefulWidget {
  const StatsExerciseDetails({super.key});

  @override
  State<StatsExerciseDetails> createState() => _StatsExerciseDetailsState();
}

class _StatsExerciseDetailsState extends State<StatsExerciseDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Exercises',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Container(),
    );
  }
}
