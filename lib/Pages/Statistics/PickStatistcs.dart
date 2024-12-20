import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/Statistics/PreviousWorkouts.dart';
import 'package:gym_freak/Pages/Statistics/Statistics.dart';

class PickStatistics extends StatefulWidget {
  const PickStatistics({super.key});

  @override
  State<PickStatistics> createState() => _PickStatisticsState();
}

class _PickStatisticsState extends State<PickStatistics> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffBB592A),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "WHERE TO GO?",
                style: TextStyle(
                    fontFamily: "Jaapokki", fontSize: 35, color: Colors.white),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => PreviousWorkouts(),
                          ),);
                      },
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 2)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "PREVIOUS WORKOUTS",
                                style: TextStyle(
                                    fontFamily: "Jaapokki", fontSize: 25, color: Colors.black),
                              ),
                              SizedBox(height: 10,),
                              Image.asset("assets/icons/report.png"),
                              SizedBox(height: 15,),
                              Text(
                                "Maintain consistency.\n"
                                    "Check performed exercises.",
                                style: TextStyle(
                                    fontFamily: "Jaapokki", fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => Statistics(),
                          ),);
                      },
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                            border: Border.all(width: 2)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                "STATISTICS",
                                style: TextStyle(
                                    fontFamily: "Jaapokki", fontSize: 25, color: Colors.black),
                              ),
                              SizedBox(height: 10,),
                              Image.asset("assets/icons/bench_press.png"),
                              SizedBox(height: 15,),
                              Text(
                                "Analyze exercises.\n"
                                    "Plan your lifting progress.",
                                style: TextStyle(
                                    fontFamily: "Jaapokki", fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
