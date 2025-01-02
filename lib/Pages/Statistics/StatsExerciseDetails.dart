import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_freak/database_classes/DatabaseHelper.dart';
import 'package:gym_freak/database_classes/ExerciseWrapper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Controllers/StatisticsController.dart';

class StatsExerciseDetails extends StatefulWidget {
  final ExerciseWrapper exerciseWrapper;
  const StatsExerciseDetails({super.key, required this.exerciseWrapper});

  @override
  State<StatsExerciseDetails> createState() => _StatsExerciseDetailsState();
}

enum Desc {
  powerCounter,
  maxWeight,
  volume,
  calendar
}

class _StatsExerciseDetailsState extends State<StatsExerciseDetails> {

  List<String> shorts = ["Power counter", "Max weight", "Volume", "Calendar"];
  List<String> descriptions =
  ["!Power counter statistics! calculates your actual strength to help you"
      " progress on your max weight. It also shows precisely how your power"
      " is increasing over time. Remember to look up on your counter number,"
      " the more you take, the more inaccurate it will be.",
  "!Max weight statistics! contains all the max weights you lifted for one"
      " repeat. It is helpful to plan another attempts and compare to power"
      " counter statictics.",
  "!Volume statistics! counts all exercise weights that belongs to one workout."
      " Helps to see if overall power is going up, along with endurance.",
  "!Calendar! tracks all your workouts that included this exercise. May seem"
      " helpful to plan next occurance of the exercise."];

  late Desc pickedStat;

  Widget getStatisticsByDesc(Desc pickedDesc){
    // charts etc
    if(pickedDesc == Desc.powerCounter)
      return Text("1");
    if(pickedDesc == Desc.maxWeight)
      return Text("2");
    if(pickedDesc == Desc.volume)
      return Text("3");
    if(pickedDesc == Desc.calendar)
      return Text("4");
    else
      return Text("Error");
  }

  Widget getStatsRoundContainer(String text){
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(45),
          border: Border.all(color: const Color(0xFF2A8CBB),width: 6)
      ),
    child: Center(child: Text(text + " kg", style: TextStyle(fontSize: 14,fontFamily: "lato"),)),);
  }

  Widget getCounters(int exerciseType, List<String> stats){
    return exerciseType == 1 ? Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text("Actual power", style: TextStyle(fontSize: 16,fontFamily: "lato"),),
            SizedBox(height: 10,),
            getStatsRoundContainer(stats[0]),
          ],
        ),
        Column(
          children: [
            Text("Max weight", style: TextStyle(fontSize: 16,fontFamily: "lato"),),
            SizedBox(height: 10,),
            getStatsRoundContainer(stats[1]),
          ],
        ),
        Column(
          children: [
            Text("Best volume", style: TextStyle(fontSize: 16,fontFamily: "lato"),),
            SizedBox(height: 10,),
            getStatsRoundContainer(stats[2]),
          ],
        ),
      ],
    ) : Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text("Workouts included", style: TextStyle(fontSize: 16,fontFamily: "lato"),),
            SizedBox(height: 10,),
            getStatsRoundContainer(stats[0]),
          ],
        ),
        Column(
          children: [
            Text("Series done", style: TextStyle(fontSize: 16,fontFamily: "lato"),),
            SizedBox(height: 10,),
            getStatsRoundContainer(stats[1]),
          ],
        ),
      ],
    );
  }

  List<TextSpan> _buildStyledText(String text) {
    List<String> parts = text.split("!");
    List<TextSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        // Zwykły tekst poza wykrzyknikami
        spans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              color: Colors.black, // Standardowy kolor
            ),
          ),
        );
      } else {
        // Tekst między wykrzyknikami (wyróżniony)
        spans.add(
          TextSpan(
            text: parts[i],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF2A8CBB), // Wyróżniony kolor
            ),
          ),
        );
      }
    }
    return spans;
  }



  @override
  void initState() {
    pickedStat = widget.exerciseWrapper.exercise.application == 1?
    Desc.powerCounter : Desc.calendar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final statsController = Provider.of<StatisticsController>(context);

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
              widget.exerciseWrapper.exercise.name,
              style: TextStyle(
                  fontSize: 28, color: Colors.white, fontFamily: 'Jaapokki'),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 26),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[100],
              child: Center(
                child: widget.exerciseWrapper.exercise.imagePath != '' ? Image.file(
                  File(widget.exerciseWrapper.exercise.imagePath),
                  height: 200,
                  fit: BoxFit.contain,
                ) :
                Icon(Icons.add,size: 128, color: Colors.grey.shade500,),
              ),
            ),
            SizedBox(height: 20,),
            getCounters(
              widget.exerciseWrapper.exercise.application,
              widget.exerciseWrapper.exercise.application == 1
                  ? [
                statsController.calculateMaxPower(widget.exerciseWrapper.exercise.name).toStringAsFixed(1),
                statsController.calculateMaxWeight(widget.exerciseWrapper.exercise.name).toStringAsFixed(1),
                statsController.calculateMaxVolume(widget.exerciseWrapper.exercise.name).toStringAsFixed(1),
              ]
                  : [
                statsController.countWorkoutsOrSeriesWithExercise(widget.exerciseWrapper.exercise.name).toString(),
                statsController.countWorkoutsOrSeriesWithExercise(widget.exerciseWrapper.exercise.name, series: true).toString(),
              ],
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Date of start:  ${DateFormat('yyyy-MM-dd').format(widget.exerciseWrapper.date)}",
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'lato'),
                ),
              ),
            ),
            if(widget.exerciseWrapper.exercise.application == 1)
              Padding(
                padding: const EdgeInsets.only(top: 15.0,left: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Counter ",
                      style: TextStyle(
                          fontSize: 16, fontFamily: 'lato'),
                    ),
                    Tooltip(
                      message: "Counter is a field to calculate your actual power.\n"
                          "It determines difference between weight and repetitions.\n"
                          "If your power is better than endurance, set it higher.\n"
                          "e.g  2.5kg -> 80kg x 5 = 90 x 1.",
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Color(0xFF2A8CBB),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Text(
                            "i",
                            style: TextStyle(
                                fontSize: 10, fontFamily: 'lato',color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      widget.exerciseWrapper.powerCounter.toString() + " kg",
                      style: TextStyle(
                          fontSize: 16, fontFamily: 'lato'),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        TextEditingController counterController = TextEditingController();
                        counterController.text = widget.exerciseWrapper.powerCounter.toString();
                        showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: Center(
                                child: Text(
                                  "Edit Counter",
                                  style: TextStyle(
                                    color: Color(0xFF2A8CBB),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Edit below to update counter.",
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  TextField(
                                    controller: counterController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: "Enter new counter value",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Color(0xFF2A8CBB), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(color: Color(0xFF2A8CBB), width: 2),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    ),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Color(0xFF2A8CBB),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Return false on cancel
                                      },
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xFF2A8CBB),
                                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () async {
                                        // Wartość z pola tekstowego
                                        final newValue = counterController.text;
                                        if (newValue.isNotEmpty) {
                                          await DatabaseHelper().updatePowerCounterByList(
                                              StatisticsController.statsManager.getExercisesByName(
                                                widget.exerciseWrapper.exercise.name
                                              ), double.parse(newValue));
                                          setState(() {
                                            widget.exerciseWrapper.powerCounter =  double.parse(newValue);
                                          });
                                        }
                                        Navigator.of(context).pop(); // Zamknij dialog
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 21,
                        height: 21,
                        decoration: BoxDecoration(
                          color: Color(0xFF2A8CBB),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20,),
            Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: 8),
              color: Color(0xFF2A8CBB),
              child: widget.exerciseWrapper.exercise.application == 1?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(Desc.values.length, (index) {
                  final style = pickedStat.index == index
                      ? TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: "lato",
                  )
                      : TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: "lato",
                  );
                  final decoration = pickedStat.index == index
                      ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  )
                      : null;

                  const padding = EdgeInsets.all(8);
                  
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        pickedStat = Desc.values[index];
                      });
                    },
                    child: Container(
                      padding: padding,
                      decoration: decoration,
                      child: Text(
                        shorts[Desc.values[index].index],
                        style: style,
                      ),
                    ),
                  );
                }),
              )
                  :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          shorts[pickedStat.index],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: "lato",
                          ),
                        ),
                      ),
                    ],
                  )
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: "lato",
                    letterSpacing: 1.1,
                  ),
                  children: _buildStyledText(descriptions[pickedStat.index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
