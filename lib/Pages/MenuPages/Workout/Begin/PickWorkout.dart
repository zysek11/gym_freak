import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../database_classes/DatabaseHelper.dart';
import '../../../../database_classes/Exercise.dart';
import '../../../../database_classes/Group.dart';

class PickWorkout extends StatefulWidget {
  const PickWorkout({super.key});

  @override
  State<PickWorkout> createState() => _PickWorkoutState();
}

class _PickWorkoutState extends State<PickWorkout> {
  late Future<Groups> pickedGroup;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    pickedGroup = getGroup(0);
  }

  Future<Groups> getGroup(int index) async {
    List<Groups> groups = await DatabaseHelper().getGroups();
    if (groups.isNotEmpty) {
      return groups[index];
    } else {
      throw Exception('No groups found');
    }
  }

  String removeL(String input) {
    return input.replaceAll(RegExp('[Ll]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A8CBB),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("PICK WORKOUT",style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'Jaapokki',
              // button text color
            ),),
            Spacer(),
            FutureBuilder<Groups>(
              future: pickedGroup,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No exercises found.'));
                } else {
                  Groups group = snapshot.data!;
                  int series = group.exercises.length * 3;
                  int estimatedLeft = series * 3;
                  int estimatedRight = series * 4;
                  return Container(
                    padding: EdgeInsets.only(top: 8,bottom: 15,left: 15,right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                group.name,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSelected = !isSelected;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? Color(0xFF2A8CBB)
                                        : Colors.black,
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? Color(0xFF2A8CBB)
                                      : Colors.transparent,
                                ),
                                width: 35,
                                height: 35,
                                child: isSelected
                                    ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 24,
                                )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25,),
                        Image.asset(
                          removeL(group.iconPath),
                          width: 128,
                          height: 128,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 25,),
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/clock.png",
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 25,),
                            Text("Around ${estimatedLeft}-${estimatedRight} minutes",
                              style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold,),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/weights.png",
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 25,),
                            Text("${group.exercises.length} exercises",
                              style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold,),),
                          ],
                        ),
                        SizedBox(height: 25,),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF2A8CBB), backgroundColor: Colors.white, // button text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // button border radius
                                side: BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            onPressed: () {
                              //Navigator.push(
                              //  context,
                              //  MaterialPageRoute(
                              //      builder: (context) =>  PickWorkout()),
                              //);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Choose from other groups',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontFamily: 'Jaapokki',
                                  // button text color
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF2A8CBB), backgroundColor: Colors.white, // button text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // button border radius
                                side: BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            onPressed: () {
                              //Navigator.push(
                              //  context,
                              //  MaterialPageRoute(
                              //      builder: (context) =>  PickWorkout()),
                              //);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Create a one-time workout',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontFamily: 'Jaapokki',
                                  // button text color
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF2A8CBB), backgroundColor: Colors.white, // button text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // button border radius
                                side: BorderSide(color: Colors.black, width: 2),
                              ),
                            ),
                            onPressed: () {
                              //Navigator.push(
                              //  context,
                              //  MaterialPageRoute(
                              //      builder: (context) =>  PickWorkout()),
                              //);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Create a new workout group',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 21,
                                  fontFamily: 'Jaapokki',
                                  // button text color
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF2A8CBB), backgroundColor: Colors.white, // button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // button border radius
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                onPressed: () {
                  //Navigator.push(
                  //  context,
                  //  MaterialPageRoute(
                  //      builder: (context) =>  PickWorkout()),
                  //);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        'NEXT STEP',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Jaapokki',
                          // button text color
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/right_arrow.png',
                      width: 30, // dostosuj rozmiar obrazka
                      fit: BoxFit.cover,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
