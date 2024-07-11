import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Exercises/AddExercise.dart';
import 'package:provider/provider.dart';

import '../../../Language/LanguageProvider.dart';
import '../../../Theme/DarkThemeProvider.dart';
import '../../../Theme/Styles.dart';
import '../../../database_classes/DatabaseHelper.dart';
import '../../../database_classes/Exercise.dart';
import 'AddGroup.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  int default_type = 0;
  late Future<List<Exercise>> exercisesFuture;
  int showMore = -1;
  List<String> options = ["A-Z", 'Z-A', 'By groups '];
  String selected_option = "A-Z";
  TextEditingController tec_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    exercisesFuture = _loadExercises();
  }

  Future<List<Exercise>> _loadExercises() async {
    List<Exercise> exercises = await DatabaseHelper().getExercises();

    switch (selected_option) {
      case "A-Z":
        exercises.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Z-A":
        exercises.sort((a, b) => b.name.compareTo(a.name));
        break;
      case "By groups":
        exercises.sort((a, b) => a.groupName.join(',').compareTo(b.groupName.join(',')));
        break;
    }

    return exercises;
  }

  Future<void> _filterExercises() async {
    List<Exercise> exercises = await exercisesFuture;
    List<Exercise> filteredExercises = exercises.where((exercise) {
      return exercise.name.contains(tec_search.text) ||
          exercise.groupName.any((group) => group.contains(tec_search.text));
    }).toList();

    setState(() {
      exercisesFuture = Future.value(filteredExercises);
    });
  }


  Future<void> _refreshExercises() async {
    setState(() {
      exercisesFuture = _loadExercises();
    });
  }

  Future<void> _removeExercise(int id) async{
    await DatabaseHelper().deleteExercise(id);
    _refreshExercises();
  }

  List<Widget> _buildGroupWidgets(List<String> groupNames) {
    return groupNames.map((name) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          color: Color(0xFF2A8CBB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          name,
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato'),
        ),
      );
    }).toList();
  }

  void _showDeleteConfirmationDialog(BuildContext context, int exerciseId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              "Confirm Deletion",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 30// Ustawienie koloru na niebieski
              ),
            ),
          ),
          content: Text("Are you sure you want to delete this exercise?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Równomierne ułożenie przycisków w poziomie
              children: [
                TextButton(
                  child: Text("Cancel",style: TextStyle(color: Color(0xFF2A8CBB), fontWeight: FontWeight.bold),),
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknięcie dialogu
                  },
                ),
                TextButton(
                  child: Text("Delete",style: TextStyle(color: Color(0xFF2A8CBB), fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknięcie dialogu
                    _removeExercise(exerciseId); // Usunięcie ćwiczenia
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Map<String, String> ls = langChange.localizedStrings;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: tec_search,
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                        hintText: 'search exercise or group',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                      ),
                      onChanged:(value){
                        if(value.isEmpty){
                          _refreshExercises();
                        }
                        else{
                          _refreshExercises();
                          _filterExercises();
                        }
                      },
                    ),
                  ),
                  Icon(
                      Icons.search,
                      size: 30,
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              color: Color(0xFF2A8CBB),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        default_type = 0;
                        _refreshExercises();
                      });
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: default_type == 0
                            ? Color(0xff24779E)
                            : Color(0xFF2A8CBB),
                      ),
                      child: Text(
                        "Exercises",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        default_type = 1;
                      });
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: default_type == 1
                            ? Color(0xff24779E)
                            : Color(0xFF2A8CBB),
                      ),
                      child: Text(
                        "Groups",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8)),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: DropdownButton<String>(
                        dropdownColor: Colors.grey.shade100,
                        value: selected_option,
                        underline: Container(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selected_option = newValue!;
                            _refreshExercises();
                          });
                        },
                        items: options.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if(default_type == 0){
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddExercise(edit: false,)),
                        );
                        if (result != null) {
                          _refreshExercises();
                        }
                      }
                      else{
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddGroup(edit: false,)),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(45)),
                      padding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Image.asset(
                        'assets/icons/add_icon.png',
                        width: 45, // dostosuj rozmiar obrazka
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: default_type == 0,
              child: Expanded(
                  child: FutureBuilder<List<Exercise>>(
                    future: exercisesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No exercises found.'));
                      } else {
                        List<Exercise> exercises = snapshot.data!;
                        return ListView.builder(
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            Exercise exercise = exercises[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showMore == index ? showMore =  -1 : showMore = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 15.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 64,
                                            height: 64,
                                            child: Image.asset(
                                              exercise.iconPath,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          // Odstęp między obrazem a tekstem
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      exercise.name,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontFamily: 'Lato',
                                                          fontWeight:
                                                          FontWeight.w400),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                    ),
                                                    Spacer(),
                                                    Icon(
                                                      Icons
                                                          .keyboard_arrow_down_rounded,
                                                      size: 22,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                // Odstęp między tytułem a podtytułem
                                                Row(
                                                  children: [
                                                    Text(
                                                      'type:  ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontFamily: 'Lato',
                                                          letterSpacing: 1.8),
                                                    ),
                                                    Text(
                                                      exercise.type.toLowerCase(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFF2A8CBB),
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontFamily: 'Lato',
                                                          letterSpacing: 1.8),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                // Odstęp między tytułem a podtytułem
                                                SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Wrap(
                                                    children: _buildGroupWidgets(
                                                      exercise.groupName
                                                          .map((group) =>
                                                          group.toLowerCase())
                                                          .toList(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (showMore == index && exercise.description.isNotEmpty)
                                        SizedBox(
                                          height: 20,
                                        ),
                                      Visibility(
                                          visible: showMore == index,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                exercise.description,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Lato',
                                                  letterSpacing: 1.8,
                                                ),
                                                overflow: TextOverflow.clip,
                                              ),
                                              if(exercise.description.isNotEmpty)
                                                SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: 60,
                                                      child: Center(
                                                        child: IconButton(
                                                          icon: Icon(Icons.edit_calendar_rounded,
                                                              size: 35,
                                                              color: Colors
                                                                  .grey.shade500),
                                                          onPressed: () async {
                                                            final result = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>  AddExercise(edit: true, exercise: exercise,)),
                                                            );
                                                            if (result != null) {
                                                              _refreshExercises();
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      height: 60,
                                                      child: Center(
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.delete_forever,
                                                              size: 35,
                                                              color: Colors
                                                                  .grey.shade500),
                                                          onPressed: () {
                                                            _showDeleteConfirmationDialog(context, exercise.id!);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
