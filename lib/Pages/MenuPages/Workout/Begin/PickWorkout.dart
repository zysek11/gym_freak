import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_freak/Pages/MenuPages/Exercises/PickGroupGroups.dart';
import 'package:lottie/lottie.dart';
import '../../../../Controllers/GroupsController.dart';
import '../../../../database_classes/DatabaseHelper.dart';
import '../../../../database_classes/Exercise.dart';
import '../../../../database_classes/Group.dart';
import '../../Exercises/AddGroup.dart';
import '../../Exercises/PickGroupExercises.dart';
import 'PickType.dart';

class PickWorkout extends StatefulWidget {
  const PickWorkout({super.key});

  @override
  State<PickWorkout> createState() => _PickWorkoutState();
}

class _PickWorkoutState extends State<PickWorkout> {
  late Future<Groups?> pickedGroup;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    pickedGroup = getFirstGroup();
  }

  Future<Groups?> getGroup(int index) async {
    await GroupsManager.gManager.initiateOrClearGroups(null,"A-Z");
    List<Groups> groups = await GroupsManager.gManager.groups;
    if (groups.isNotEmpty) {
      try {
        Groups group = groups.firstWhere((group) => group.id == index);
        return group;
      } catch (e) {
        throw Exception('Group with id $index not found');
      }
    } else {
      return null;
    }
  }

  Future<Groups?> getFirstGroup() async {
    await GroupsManager.gManager.initiateOrClearGroups(null,"A-Z");
    List<Groups> groups = await GroupsManager.gManager.groups;
    if (groups.isNotEmpty) {
      return groups[0];
    } else {
      return null;
    }
  }

  void getOneTimeGroup(List<Exercise> listE, String type) async{
    // do 1 typu ida tylko cwiczenia z grupa, do 2 wszystkie
    Iterable<int> exerciseIds;

    // Sprawdzamy, czy typ to "combine", jeśli tak, to dodajemy ćwiczenia z grupą
    if (type == "combine") {
      exerciseIds = listE.where((exercise) => exercise.groups!.isNotEmpty).map((exercise) => exercise.id!);
    } else {
      // Inaczej zostawiamy listę jak jest
      exerciseIds = listE.map((exercise) => exercise.id!);
    }
    if(context.mounted){
      final result = type == "combine" ?
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>  PickGroupGroups(editables: exerciseIds,)),
      )
          : await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PickGroupExercises(oneTimeW: true, editables: exerciseIds,)), // AddExercisePage to strona dodawania ćwiczenia
      );

      if (result != null) {
        setState(() {
          pickedGroup = Future.value(result); // Dodawanie nowego ćwiczenia do listy
        });
      }
    }
  }

  Future<Groups> getLatestGroup() async {
    await GroupsManager.gManager.initiateOrClearGroups(null,"A-Z");
    List<Groups> groups = await GroupsManager.gManager.groups;
    if (groups.isNotEmpty) {
      return groups.last;
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
            FutureBuilder<Groups?>(
              future: pickedGroup,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child:
                    Container(
                        padding: EdgeInsets.only(top: 15,bottom: 15,left: 5,right:5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2,color: Colors.black),
                        color: Colors.white,
                      ),
                        child: Column(
                          children: [
                            Lottie.asset("assets/animations/no_group_anim.json"),
                            Text('Where are these groups?',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                              ),),
                          ],
                        ))
                  );
                } else if (!snapshot.hasData) {
                  return Center(child: Container(
                      padding: EdgeInsets.only(top: 15,bottom: 15,left: 5,right:5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2,color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Lottie.asset("assets/animations/no_group_anim.json"),
                          Text('Where are these groups?',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato',
                            ),),
                        ],
                      )));
                } else {
                  Groups group = snapshot.data!;
                  int series = group.exercises.length * 3;
                  int estimatedLeft = series * 3;
                  int estimatedRight = series * 4;
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        isSelected = !isSelected;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 8,bottom: 15,left: 15,right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2,color: Colors.black),
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
                              Text(group.exercises.length < 2 ? "${group.exercises.length} exercise":
                              "${group.exercises.length} exercises",
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
                              onPressed: () async {
                                getOneTimeGroup(group.exercises,"combine");
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Combine exercises from groups',
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
                                getOneTimeGroup(group.exercises,"select");
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Pick exercises for a workout',
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
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  AddGroup(edit: false)),
                                );
                                if (result != null) {
                                  setState(() {
                                    pickedGroup = getLatestGroup();
                                  });
                                }
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
                // Zmodyfikowana część kodu
                onPressed: () async {
                  final Groups? selectedGroup = await pickedGroup; // Czekamy na zakończenie Future
                  if(isSelected && context.mounted){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PickType(pg: selectedGroup!), // Przekazanie obiektu Groups do PickType
                      ),
                    );
                  }
                  else{
                    const snackBar = SnackBar(
                      content: Text(
                        'Remember to select exercise before going to the next step!',
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color(0xFFFFFFFF),
                    );
                    if(context.mounted){
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
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
