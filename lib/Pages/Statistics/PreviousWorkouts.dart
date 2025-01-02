import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/Statistics/WorkoutDetails.dart';
import 'package:provider/provider.dart';
import '../../Controllers/StatisticsController.dart';
import '../../database_classes/Workout.dart';

class PreviousWorkouts extends StatefulWidget {
  const PreviousWorkouts({super.key});

  @override
  State<PreviousWorkouts> createState() => _PreviousWorkoutsState();
}

class _PreviousWorkoutsState extends State<PreviousWorkouts> {
  TextEditingController tecSearch = TextEditingController();
  bool isAscending = false; // Flaga dla sortowania
  int showMore = -1;

  @override
  void initState() {
    super.initState();
    // Pobranie listy treningów na początku
    Future.microtask(() => Provider.of<StatisticsController>(context, listen: false).getWorkouts());
  }

  @override
  Widget build(BuildContext context) {
    final statsController = Provider.of<StatisticsController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Previous Workouts',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                isAscending = !isAscending; // Przełącz sortowanie
                statsController.sortWorkoutsByDate( descending: !isAscending);
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Pasek wyszukiwania
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 8, top: 16),
              child: TextFormField(
                controller: tecSearch,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: 'Search workout by name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff2a8cbb)
                    )
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  suffixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  statsController.filterWorkoutsByName(value);
                },
              ),
            ),
            const SizedBox(height: 10),
            // Lista przewijalna treningów
            Expanded(
              child: statsController.workouts.isEmpty
                  ? const Center(
                child: Text(
                  'No workouts found.',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: statsController.workouts.length,
                itemBuilder: (context, index) {
                  final Workout workout = statsController.workouts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          if(showMore == -1){
                            showMore = index;
                          }
                          else if(index != showMore && showMore != -1){
                            showMore = index;
                          }
                          else{
                            showMore = -1;
                          }
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${workout.date.day}.${workout.date.month}.${workout.date.year}",
                            style: TextStyle(fontSize: 20, color: Colors.black,
                            fontFamily: 'Lato'),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffF8F8F8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.asset('assets/group_icons/typeL0.png'),
                                          SizedBox(width: 15,),
                                          Text(workout.name, style: TextStyle(
                                            fontFamily: "Lato",
                                            fontSize: 20
                                          ),)
                                        ],
                                      ),
                                      SizedBox(height: 15,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/icons/clock.png', width: 32, height: 32,),
                                            SizedBox(width: 15,),
                                            Text(workout.time.inMinutes.toString() + " minutes long",
                                              style: TextStyle(
                                                fontFamily: "Lato",
                                                fontSize: 17
                                            ),)
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Row(
                                          children: [
                                            Image.asset('assets/icons/weights.png', width: 32, height: 32,),
                                            SizedBox(width: 15,),
                                            Text(workout.exercises.length.toString() + " exercises   ",
                                              style: TextStyle(
                                                  fontFamily: "Lato",
                                                  fontSize: 17
                                              ),),
                                            showMore == index ? Icon(Icons.keyboard_arrow_up, size: 25,) :
                                            Icon(Icons.keyboard_arrow_down, size: 25,),
                                          ],
                                        ),
                                      ),
                                      if(showMore == index)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15.0, top: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(
                                              workout.exercises.length,
                                                  (wIndex) => Column(children:[
                                                    Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "Exercise ${wIndex + 1}\n",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(0xff2a8cbb), // Kolor niebieski dla "Exercise"
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: "${workout.exercises[wIndex].exercise.name}",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black, // Kolor czarny dla nazwy ćwiczenia
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    SizedBox(height: 10,),
                                                    ])
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      SizedBox(height: 30,),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WorkoutDetails(
                                                detailedWorkout: workout,
                                              ),
                                            ),
                                          );
                                        },
                                          child: Icon(Icons.read_more, size: 30, color: Color(0xff333333),)),
                                      SizedBox(height: 40,),
                                      GestureDetector(
                                        onTap: (){
                                          showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                title: Center(
                                                  child: Text(
                                                    "Deletion",
                                                    style: TextStyle(
                                                      color: Color(0xFF2A8CBB),
                                                      fontSize: 22,
                                                    ),
                                                  ),
                                                ),
                                                content: Text(
                                                  "Are you sure you want to delete this workout from history?",
                                                  style: TextStyle(fontSize: 16),
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
                                                          "Delete",
                                                          style: TextStyle(
                                                            color: Color(0xFFFFFFFF),
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        onPressed: () async {
                                                          await statsController.removeWorkout(workout.id!, !isAscending);
                                                          Navigator.of(context).pop(); // Return true on delete
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                          child: Icon(Icons.delete_forever, size: 30, color: Color(0xff333333))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
