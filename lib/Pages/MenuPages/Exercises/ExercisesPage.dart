import 'package:flutter/material.dart';
import 'package:gym_freak/Controllers/ExercisesController.dart';
import 'package:gym_freak/Controllers/GroupsController.dart';
import 'package:gym_freak/Pages/MenuPages/Exercises/AddExercise.dart';
import 'package:provider/provider.dart';

import '../../../Language/LanguageProvider.dart';
import '../../../Theme/DarkThemeProvider.dart';
import '../../../Theme/Styles.dart';
import '../../../database_classes/DatabaseHelper.dart';
import '../../../database_classes/Exercise.dart';
import '../../../database_classes/Group.dart';
import 'AddGroup.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  int default_type = 0;
  int showMore = -1;
  List<String> options = ["A-Z", 'Z-A', 'By type'];
  List<String> optionsB = ["A-Z", 'Z-A'];
  String selected_option = "A-Z";
  String selected_optionB = "A-Z";
  TextEditingController tec_search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExercises();
    _loadGroups();
  }

  // EXERCISES FUNCTIONS ETC //

  Future<void> _loadExercises() async {
    await ExercisesManager.eManager.initiateOrClearExercises(null, selected_option);
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

  // EXERCISES AND GROUPS FUNCTIONS FOR BOTH //

  void _showDeleteConfirmationDialog(
      BuildContext context, Exercise? exercise, Groups? groups) {
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
                fontSize: 30, // Ustawienie koloru na niebieski
              ),
            ),
          ),
          content: exercise != null
              ? Text("Are you sure you want to delete this exercise?")
              : Text("Are you sure you want to delete this group?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // Równomierne ułożenie przycisków w poziomie
              children: [
                TextButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF2A8CBB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknięcie dialogu
                  },
                ),
                TextButton(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Color(0xFF2A8CBB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Zamknięcie dialogu
                    if (exercise != null) {
                      GroupsManager.gManager.updateExerciseGroups(<int>[], exercise);
                      ExercisesManager.eManager.removeExercise(exercise.id!);
                      ExercisesManager.eManager.sortExercises(selected_option);
                    } else if (groups != null) {
                      // Usuwanie grupy z wszystkich ćwiczeń
                      ExercisesManager.eManager.removeGroupNamesFromExercises(groups.id!);
                      // Usuwanie grupy z bazy danych
                      GroupsManager.gManager.removeGroup(groups.id!);
                      GroupsManager.gManager.sortGroups(selected_optionB);
                    }
                    showMore = -1;
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }


  // GROUP FUNCTIONS ETC //

  Future<void> _loadGroups() async {
    await GroupsManager.gManager.initiateOrClearGroups(null, selected_optionB);
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
                      onChanged: (value) {
                        if (value.isEmpty) {
                          if (default_type == 0) {
                            ExercisesManager.eManager
                                .filterExercises(tec_search.text, selected_option);
                          } else {
                            GroupsManager.gManager
                                .filterGroups(tec_search.text, selected_optionB);
                          }
                        } else {
                          if (default_type == 0) {
                            ExercisesManager.eManager
                                .filterExercises(tec_search.text, selected_option);
                          } else {
                            GroupsManager.gManager
                                .filterGroups(tec_search.text, selected_optionB);
                          }
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
                        showMore = -1;
                        ExercisesManager.eManager
                            .initiateOrClearExercises(tec_search.text,selected_option);
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
                        showMore = -1;
                        GroupsManager.gManager
                            .initiateOrClearGroups(tec_search.text,selected_optionB);
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
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: default_type == 0
                          ? DropdownButton<String>(
                              dropdownColor: Colors.grey.shade100,
                              value: selected_option,
                              underline: Container(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selected_option = newValue!;
                                });
                                ExercisesManager.eManager.sortExercises(selected_option);
                              },
                              items: options.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17),
                                  ),
                                );
                              }).toList(),
                            )
                          : DropdownButton<String>(
                              dropdownColor: Colors.grey.shade100,
                              value: selected_optionB,
                              underline: Container(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selected_optionB = newValue!;
                                });
                                GroupsManager.gManager.sortGroups(selected_optionB);
                              },
                              items: optionsB.map<DropdownMenuItem<String>>(
                                  (String value) {
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
                      if (default_type == 0) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddExercise(
                                    edit: false,
                                  )),
                        );
                        if (result != null) {
                          ExercisesManager.eManager
                              .initiateOrClearExercises(tec_search.text,selected_option);
                        }
                      } else {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddGroup(
                                    edit: false,
                                  )),
                        );
                        if (result != null) {
                          GroupsManager.gManager
                              .initiateOrClearGroups(tec_search.text,selected_optionB);
                        }
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
            Container(
              child: Expanded(
                child: default_type == 0
                    ? Consumer<ExercisesManager>(
                        builder: (context, manager, child) {
                          return FutureBuilder<List<Exercise>>(
                            future: manager.exercises,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Center(
                                    child: Text('No exercises found.'));
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
                                            showMore == index
                                                ? showMore = -1
                                                : showMore = index;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 15.0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4.0),
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
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        // Użycie Expanded, aby tekst dostosował się do dostępnego miejsca
                                                        Expanded(
                                                          child: Text(
                                                            exercise.name,
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors.black,
                                                              fontFamily: 'Lato',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                            overflow: TextOverflow.ellipsis, // Dodaje elipsy, jeśli tekst jest za długi
                                                            maxLines: 1, // Ogranicza do jednej linii
                                                            softWrap: false,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Icon(
                                                          Icons.keyboard_arrow_down_rounded,
                                                          size: 22,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20,),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal:  16.0),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/exercise.png",
                                                      width: 32,
                                                      height: 32,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    SizedBox(
                                                      width: 24,
                                                    ),
                                                    Text(
                                                      "type:",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontFamily:
                                                          'Lato',
                                                          letterSpacing:
                                                          1.8),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      exercise.type
                                                          .toLowerCase(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontFamily:
                                                          'Lato',
                                                          letterSpacing:
                                                          1.8),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 20,),
                                              if(exercise.groups != null)
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                    Axis.horizontal,
                                                    child: Wrap(
                                                      children:
                                                      _buildGroupWidgets(
                                                        exercise.groups
                                                            !.map((group) =>
                                                            group.name
                                                                .toLowerCase())
                                                            .toList(),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              if (showMore == index &&
                                                  exercise
                                                      .description.isNotEmpty)
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              Visibility(
                                                  visible: showMore == index,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        exercise.description,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'Lato',
                                                          letterSpacing: 1.8,
                                                        ),
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                      if (exercise.description
                                                          .isNotEmpty)
                                                        SizedBox(height: 10),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: 60,
                                                              child: Center(
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .edit_calendar_rounded,
                                                                      size: 35,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade500),
                                                                  onPressed:
                                                                      () async {
                                                                    final result =
                                                                        await Navigator
                                                                            .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              AddExercise(
                                                                                edit: true,
                                                                                exercise: exercise,
                                                                              )),
                                                                    );
                                                                    if (result !=
                                                                        null) {
                                                                      ExercisesManager
                                                                          .eManager
                                                                          .initiateOrClearExercises(
                                                                              null,selected_option);
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
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                      Icons
                                                                          .delete_forever,
                                                                      size: 35,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade500),
                                                                  onPressed:
                                                                      () {
                                                                    _showDeleteConfirmationDialog(
                                                                        context,
                                                                        exercise,null);
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
                          );
                        },
                      )
                    : // For groups
                      Consumer<GroupsManager>(
                      builder: (context, manager, child) {
                      return FutureBuilder<List<Groups>>(
                          future: manager.groups,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(child: Text('No groups found.'));
                            } else {
                              List<Groups> groups = snapshot.data!;
                              return ListView.builder(
                                itemCount: groups.length,
                                itemBuilder: (context, index) {
                                  Groups group = groups[index];
                                  int series = group.exercises.length * 3;
                                  int estimatedLeft = series * 3;
                                  int estimatedRight = series * 4;
                                  //print("id grupy " + group.name + ": "+ group.id.toString());
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showMore == index
                                              ? showMore = -1
                                              : showMore = index;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 15.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 4.0),
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
                                                    group.iconPath,
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
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              group.name,
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  color:
                                                                      Colors.black,
                                                                  fontFamily:
                                                                      'Lato',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10,),
                                                          Icon(
                                                            Icons
                                                                .keyboard_arrow_down_rounded,
                                                            size: 22,
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15,
                                                  top: 25,
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/clock.png",
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Text(
                                                    series  != 0 ? "Around ${estimatedLeft}-${estimatedRight} minutes"
                                                      : "Add exercises to calculate time",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15.0,
                                                  right: 15,
                                                  bottom: 10,
                                                  top: 5),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/weights.png",
                                                    width: 32,
                                                    height: 32,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(
                                                    width: 25,
                                                  ),
                                                  Text(
                                                    group.exercises.isEmpty
                                                        ? "No exercises" // Wyświetl "No exercises" gdy liczba ćwiczeń wynosi 0
                                                        : group.exercises.length == 1
                                                        ? "${group.exercises.length} exercise" // Wyświetl "1 exercise", gdy liczba ćwiczeń to 1
                                                        : "${group.exercises.length} exercises", // Wyświetl liczbę ćwiczeń, gdy jest ich więcej niż 1
                                                    style: TextStyle(fontSize: 18),
                                                  )
                                                ],
                                              ),
                                            ),
                                            if (showMore == index)
                                              SizedBox(
                                                height: 10,
                                              ),
                                            Visibility(
                                                visible: showMore == index,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ...group.exercises
                                                        .asMap()
                                                        .entries
                                                        .map((entry) {
                                                      int index = entry.key;
                                                      Exercise exercise =
                                                          entry.value;
                                                      return Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                'Exercise ${index + 1}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: 17,
                                                                    color: Color(
                                                                        0xFF2A8CBB))),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              exercise.name,
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                            SizedBox(height: 5),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: 60,
                                                            child: Center(
                                                              child: IconButton(
                                                                icon: Icon(
                                                                    Icons
                                                                        .edit_calendar_rounded,
                                                                    size: 35,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500),
                                                                onPressed:
                                                                    () async {
                                                                  final result =
                                                                      await Navigator
                                                                          .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                AddGroup(
                                                                                  edit: true,
                                                                                  group: group,
                                                                                )),
                                                                  );
                                                                  if (result !=
                                                                      null) {
                                                                    GroupsManager
                                                                        .gManager
                                                                        .initiateOrClearGroups(
                                                                        null,selected_optionB);
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
                                                                    Icons
                                                                        .delete_forever,
                                                                    size: 35,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade500),
                                                                onPressed: () {
                                                                  _showDeleteConfirmationDialog(
                                                                      context,
                                                                      null,
                                                                      group);
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
                        );},
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
