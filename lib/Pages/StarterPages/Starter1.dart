import 'package:flutter/material.dart';

class StarterOne extends StatefulWidget {
  const StarterOne({super.key});

  @override
  State<StarterOne> createState() => _StarterOneState();
}

class _StarterOneState extends State<StarterOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("s1"),
        ),
      ),
    );
  }
}
