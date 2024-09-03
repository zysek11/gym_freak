import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Exercises/PickGroupExercises.dart';
import 'package:gym_freak/database_classes/Exercise.dart';

import '../../../database_classes/DatabaseHelper.dart';
import '../../../database_classes/Group.dart';

class AddGroup extends StatefulWidget {
  final int edit;
  final Groups? group;

  const AddGroup({super.key,required this.edit, this.group});

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {

  late String selectedImage; // Domyślny obrazek
  late int selectedImageIndex;
  TextEditingController name_tec = TextEditingController();
  List<Exercise> exercises = [];

  final List<String> images = List.generate(
    8,
        (index) => 'assets/group_icons/typeL$index.png',
  );
  bool _isLoading = true;

  void _navigateAndAddExercise(BuildContext context) async {
    Iterable<int> exerciseIds = exercises.map((exercise) => exercise.id!).toList();
     final result = await Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => PickGroupExercises(oneTimeW: false,editables: exerciseIds,)), // AddExercisePage to strona dodawania ćwiczenia
     );

     if (result != null) {
       setState(() {
         exercises = result; // Dodawanie nowego ćwiczenia do listy
       });
     }
  }

  int getImageIndex(String path) {
    final regex = RegExp(r'\d+');
    final match = regex.firstMatch(path);
    int index = 0;
    if (match != null) {
      index = int.parse(match.group(0)!);
    }
    return index;
  }

  void loadData(){
    selectedImage = removeL(widget.group!.iconPath);
    selectedImageIndex = getImageIndex(selectedImage);
    name_tec.text = widget.group!.name;
    exercises = widget.group!.exercises;
  }

  String removeL(String input) {
    return input.replaceAll(RegExp('[Ll]'), '');
  }

  Future<void> addGroup() async {
    if (widget.edit == 0) {
      Groups group = Groups(
          id: widget.group!.id,
          name: name_tec.text,
          iconPath: images[selectedImageIndex],
          exercises: exercises
      );
      await DatabaseHelper().updateGroup(group);
    } else  {
      Groups group = Groups(
          name: name_tec.text,
          iconPath: images[selectedImageIndex],
          exercises: exercises
      );
      await DatabaseHelper().insertGroup(group);
    }
  }

  @override
  void initState() {
    super.initState();
    selectedImage = 'assets/group_icons/type0.png';
    selectedImageIndex = 0;
    if(widget.edit == 0){
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[100],
                          // Tło kontenera, możesz zmienić kolor
                          child: Center(
                            child: Image.asset(
                              selectedImage,
                              // Zmień na rzeczywistą ścieżkę do obrazka
                              width: 128,
                              height: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "1. Pick icon",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    String path = images[index];
                                    path = path.replaceAll('L', '');
                                    print("sciezka: " + path);
                                    selectedImage = path;
                                    selectedImageIndex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedImageIndex == index
                                        ? Color(0xFFA5EEFF)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.asset(images[index]),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "2. Give a name",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: name_tec,
                            style: TextStyle(fontSize: 18),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF2A8CBB)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF2A8CBB)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "3. Pick exercises",
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[100],
                            ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...exercises.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    Exercise exercise = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Exercise ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 17, color: Color(0xFF2A8CBB))),
                                          SizedBox(height: 5),
                                          Text(exercise.name, style: TextStyle(fontSize: 17),),
                                          SizedBox(height: 5),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => _navigateAndAddExercise(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF2A8CBB), // Kolor przycisku
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5), // Mniejsze zaokrąglenie rogów
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Edit exercises  ", style: TextStyle(fontSize: 18, color: Colors.white)),
                                        Icon(Icons.add, size: 18, color: Colors.white)
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10), // Dodatkowy odstęp na dole
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF2A8CBB),
                    backgroundColor: Color(0xFF2A8CBB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // button border radius
                    ),
                  ),
                  onPressed: () async {
                    if (name_tec.text.isNotEmpty && exercises.isNotEmpty) {
                      await addGroup();
                      if (mounted) {
                          Navigator.pop(context, true);
                      }
                    } else {
                      const snackBar = SnackBar(
                        content: Text(
                          'Do not forget about name and exercises!',
                          style: TextStyle(color: Colors.black),
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFFFFFFFF),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.edit == 0 ? "EDIT GROUP" : 'ADD GROUP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Jaapokki',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
