import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../Controllers/ExerciseTypesManager.dart';
import '../../../Controllers/GroupsController.dart';
import '../../../database_classes/DatabaseHelper.dart';
import '../../../database_classes/Exercise.dart';
import '../../../database_classes/Group.dart';

class AddExercise extends StatefulWidget {
  final bool edit;
  final Exercise? exercise;

  const AddExercise({super.key, required this.edit, this.exercise});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  // Editable - controllers and other for loading data or initiating
  late String selectedImage; // Domyślny obrazek
  late int selectedImageIndex;
  late bool check_applic;
  MultiSelectController msc = MultiSelectController();
  TextEditingController name_tec = TextEditingController();
  TextEditingController desc_tec = TextEditingController();
  late String selectedCategory;
  bool _isLoading = true;
  late List<Groups> groups;

  final List<String> images = List.generate(
    8,
        (index) => 'assets/workout_icons/typeL$index.png',
  );

  final ExerciseTypesManager _exerciseTypesManager = ExerciseTypesManager();

  void initializeData() {
    check_applic = true;
    selectedImage = 'assets/workout_icons/typeL0.png';
    selectedImageIndex = 0;
    selectedCategory = _exerciseTypesManager.allExercises.first['name'];
  }

  void loadData() {
    selectedImage = removeL(widget.exercise!.iconPath);
    selectedImageIndex = getImageIndex(selectedImage);
    name_tec.text = widget.exercise!.name;
    selectedCategory = widget.exercise!.type;
    check_applic = widget.exercise!.application == 0 ? false : true;

    // Ustaw opcje dostępnych grup
    msc.setOptions(_mapGroupsToValueItems(groups));

    // Znajdź tylko te grupy, które są na liście dostępnych grup
    List<Groups> validSelectedGroups = widget.exercise!.groups!.where((group) {
      return groups.any((g) => g.id == group.id); // Sprawdź, czy grupa z ćwiczenia istnieje w dostępnych grupach
    }).toList();

    // Debugowanie - wyświetl grupy
    print("All groups: ${groups.map((g) => g.name).toList()}");
    print("Valid selected groups: ${validSelectedGroups.map((g) => g.name).toList()}");

    // Ustaw wybrane grupy, ale sprawdź, czy są na liście opcji
    if (validSelectedGroups.isNotEmpty) {
      msc.setSelectedOptions(_mapGroupsToValueItems(validSelectedGroups));
    } else {
      print('No valid groups found for this exercise');
    }

    desc_tec.text = widget.exercise!.description;
  }

  Future<void> _showAddExerciseTypeDialog() async {
    TextEditingController customExerciseController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Custom Exercise Type"),
          content: TextField(
            controller: customExerciseController,
            decoration: InputDecoration(hintText: "Enter exercise type"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (customExerciseController.text.isNotEmpty) {
                  await _exerciseTypesManager.addCustomExercise(customExerciseController.text);
                  setState(() {
                    selectedCategory = customExerciseController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadGroupsAndTypes() async {
    List<Groups> groupList = await DatabaseHelper().getGroups();
    setState(() {
      groups = groupList; // Używamy teraz pełnych obiektów Groups
      _isLoading = false;
    });
  }

  List<ValueItem> _mapGroupsToValueItems(List<Groups> groups) {
    return groups.map((group) => ValueItem(label: group.name, value: group.id)).toList();
  }

  List<Groups> _valueItemsToGroupList(List<ValueItem> selectedGroups) {
    List<Groups> matchedGroups = [];
    // Iteruj po wszystkich dostępnych grupach
    for (var group in groups) {
      // Sprawdź, czy id grupy pokrywa się z value w selectedGroups
      for (var selectedGroup in selectedGroups) {
        if (group.id == selectedGroup.value) {
          matchedGroups.add(group); // Dodaj grupę do listy, jeśli jest zgodność
          break; // Przestań iterować po selectedGroups, jeśli dopasowanie zostało znalezione
        }
      }
    }
    return matchedGroups;
  }

  void onChanged(bool? value) {
    setState(() {
      check_applic = value ?? false;
    });
  }

  void onChanged2(bool? value) {
    setState(() {
      check_applic = !value!;
    });
  }

  String removeL(String input) {
    return input.replaceAll(RegExp('[Ll]'), '');
  }

  Future<void> addExercise() async {
    if (widget.edit) {
      Exercise exercise = Exercise(
        id: widget.exercise!.id,
        name: name_tec.text,
        type: selectedCategory,
        application: check_applic ? 1 : 0,
        iconPath: images[selectedImageIndex],
        groups: _valueItemsToGroupList(msc.selectedOptions), // Przechowujemy teraz obiekty Groups
        description: desc_tec.text,
      );

      // Zaktualizuj ćwiczenie
      await DatabaseHelper().updateExercise(exercise);

      // Pobierz ID grup, które zostały wybrane
      List<int> remainingGroupIds = _valueItemsToGroupList(msc.selectedOptions).map((group) => group.id!).toList();

      // aktualizuj ćwiczenia z grup
      await GroupsManager.gManager.updateExerciseGroups(remainingGroupIds, exercise);
    } else {
      // Logika dla nowego ćwiczenia
      Exercise exercise = Exercise(
        name: name_tec.text,
        type: selectedCategory,
        application: check_applic ? 1 : 0,
        iconPath: images[selectedImageIndex],
        groups: _valueItemsToGroupList(msc.selectedOptions), // Przechowujemy teraz obiekty Groups
        description: desc_tec.text,
      );
      await DatabaseHelper().insertExercise(exercise);
      Exercise? exerciseWithId = await DatabaseHelper().getLastExercise();
      // Pobierz ID grup, które zostały wybrane
      if(exerciseWithId != null && msc.selectedOptions.isNotEmpty){
        print("Nie null, id: " + exerciseWithId.id.toString());
        List<int> remainingGroupIds = _valueItemsToGroupList(msc.selectedOptions).map((group) => group.id!).toList();
        // aktualizuj ćwiczenia z grup
        await GroupsManager.gManager.updateExerciseGroups(remainingGroupIds, exerciseWithId);
      }
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

  @override
  void initState() {
    super.initState();
    initializeData();
    _loadGroupsAndTypes().then((value) {
      if (widget.edit) {
        loadData();
      }
    });
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
                      child: Center(
                        child: Image.asset(
                          selectedImage,
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
                                selectedImage = images[index].replaceAll('L', '');
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
                        "3. Choose a type",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _exerciseTypesManager.allExercises
                                    .any((exercise) => exercise['name'] == selectedCategory)
                                    ? selectedCategory
                                    : null,  // Ensure the selected value exists in the dropdown
                                items: _exerciseTypesManager.allExercises.map((exercise) {
                                  return DropdownMenuItem<String>(
                                    value: exercise['name'],  // Ensure the name is unique
                                    child: Text(exercise['name'], style: TextStyle(fontSize: 20)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedCategory = newValue!;
                                  });
                                },
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _showAddExerciseTypeDialog,
                            ),
                            Spacer(),
                            if(_exerciseTypesManager.checkIfCustom(selectedCategory))
                              ...[
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () async {
                                      bool message = await ExerciseTypesManager().removeCustomExercise(selectedCategory);
                                      if(!message){
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'There are exercises related to this type, change it first.',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Color(0xFFFFFFFF),
                                        );
                                        if(context.mounted){
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      }
                                      setState(() {});
                                  },
                                ),
                                const Spacer()
                              ]
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "4. Pick an application",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Checkbox(
                            value: check_applic,
                            activeColor: Color(0xFF2A8CBB),
                            onChanged: onChanged,
                          ),
                          Text(
                            "Basic, with weight and repeats",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Checkbox(
                            value: !check_applic,
                            activeColor: Color(0xFF2A8CBB),
                            onChanged: onChanged2,
                          ),
                          Text(
                            "Shortened, with sets only",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "5. Pick groups",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : MultiSelectDropDown(
                        controller: msc,
                        onOptionSelected: (options) {
                          debugPrint(options.toString());
                        },
                        options: _mapGroupsToValueItems(groups),
                        maxItems: 2,
                        selectionType: SelectionType.multi,
                        chipConfig: const ChipConfig(
                            wrapType: WrapType.wrap,
                            backgroundColor: Color(0xFF2A8CBB)),
                        dropdownHeight: 300,
                        optionTextStyle: const TextStyle(fontSize: 16),
                        selectedOptionIcon: const Icon(
                          Icons.check_circle,
                          color: Color(0xFF2A8CBB),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "6. Short description",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: desc_tec,
                          maxLines: 4,
                          maxLength: 150,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                  if (name_tec.text.isNotEmpty) {
                    await addExercise();
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } else {
                    const snackBar = SnackBar(
                      content: Text(
                        'Do not forget about name!',
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
                        widget.edit ? "EDIT EXERCISE" : 'ADD EXERCISE',
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
        ),
      ),
    );
  }
}
