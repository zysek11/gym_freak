import 'dart:ui';

import 'package:flutter/material.dart';

import '../../database_classes/Workout.dart';

class WorkoutDetails extends StatefulWidget {
  final Workout detailedWorkout;

  const WorkoutDetails({super.key, required this.detailedWorkout});

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  late Workout dw;

  @override
  void initState() {
    dw = widget.detailedWorkout;
    super.initState();
  }

  double countVolume() {
    double volume = 0.0;
    for (int i = 0; i < dw.exercises.length; i++) {
      if(dw.exercises[i].exercise.application != 0){
        for (int j = 0; j < dw.exercises[i].series - 1; j++) {
          volume +=
          (dw.exercises[i].weights![j] * dw.exercises[i].repetitions![j]);
        }
      }
    }
    return volume;
  }

  double countExerciseVolume(int index) {
    double volume = 0.0;
    for (int i = 0; i < dw.exercises[index].series - 1; i++) {
      volume += (dw.exercises[index].weights![i] *
          dw.exercises[index].repetitions![i]);
    }
    return volume;
  }

  int percentageOfVolume(double max_cev, double cev) {
    if (max_cev != 0) {
      double d = cev / max_cev;
      return (d * 100).toInt();
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8CBB),
        toolbarHeight: 68,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          // Zwiększanie paddingu
          child: Align(
            alignment: Alignment.bottomCenter, // Ustawienie zawartości
            child: Text(
              dw.name,
              style: TextStyle(
                  fontSize: 28, color: Colors.white, fontFamily: 'Jaapokki'),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 26),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 25, bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    color: Color(0xfff5f5f5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        // Kolor cienia z przezroczystością
                        offset: Offset(0, 4),
                        // Przesunięcie cienia (x, y)
                        blurRadius: 8,
                        // Promień rozmycia
                        spreadRadius: 2, // Rozpiętość cienia
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: Image.asset(
                                'assets/group_icons/type0.png',
                                width: 128,
                                height: 128,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset("assets/icons/clock.png"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      dw.time.inMinutes.toString() +
                                          " minutes long",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontFamily: "Lato"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Image.asset("assets/icons/weights.png"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      dw.exercises.length.toString() +
                                          " exercises",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontFamily: "Lato"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                        "assets/icons/satisfaction.png"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "satisfaction:  " +
                                          dw.satisfaction.toString() +
                                          "/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontFamily: "Lato"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Image.asset("assets/icons/intensity.png"),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "intensity:  " +
                                          dw.intensity.toString() +
                                          "/5",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontFamily: "Lato"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        color: const Color(0xFF2A8CBB),
                        width: double.maxFinite,
                        child: Center(
                          child: Text(
                            countVolume() > 0.0 ? "TOTAL VOLUME  " +
                                countVolume().toString() +
                                " KGS" : "ONLY SETS EXERCISES",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: "Lato"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dw.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = dw.exercises[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Exercise ${(index + 1)}  ",
                                    // Pierwsza część tekstu
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: const Color(0xFF2A8CBB),
                                        fontFamily: 'Lato' // Czarny kolor
                                        ),
                                  ),
                                  TextSpan(
                                    text: exercise.exercise.name,
                                    // Druga część tekstu
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black, // Niebieski kolor
                                        fontFamily: 'Lato'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            color: Color(0xfff5f5f5),
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(top: 20, bottom: 15),
                            child: Column(
                              children: [
                                exercise.exercise.application == 1
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: exercise.series - 1,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF2A8CBB),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  45)),
                                                    ),
                                                    child: Text(
                                                      "${index + 1}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily: "Lato"),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF2A8CBB),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  45)),
                                                    ),
                                                    child: Text(
                                                      " ${exercise.weights![index]} kgs ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily: "Lato"),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "x",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontFamily: "Lato"),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 12),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFF2A8CBB),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  45)),
                                                    ),
                                                    child: Text(
                                                      " ${exercise.repetitions![index]} repeats ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily: "Lato"),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF2A8CBB),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(45)),
                                                ),
                                                child: Text(
                                                  "${exercise.series -1} series",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontFamily: "Lato"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if(exercise.exercise.application == 1) Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A8CBB),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            // Kolor cienia z przezroczystością
                                            offset: Offset(0, 4),
                                            // Przesunięcie cienia (x, y)
                                            blurRadius: 8,
                                            // Promień rozmycia
                                            spreadRadius:
                                                2, // Rozpiętość cienia
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        percentageOfVolume(countVolume(),
                                                    countExerciseVolume(index))
                                                .toString() +
                                            "%",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: "Lato"),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 15),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A8CBB),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            // Kolor cienia z przezroczystością
                                            offset: Offset(0, 4),
                                            // Przesunięcie cienia (x, y)
                                            blurRadius: 8,
                                            // Promień rozmycia
                                            spreadRadius:
                                                2, // Rozpiętość cienia
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        exercise.exercise.application == 1 ? "VOLUME  ${countExerciseVolume(index)} KGS":
                                        "SETS ONLY",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: "Lato"),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
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
