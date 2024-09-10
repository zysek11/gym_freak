import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

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

  final List<String> images = List.generate(
    8,
        (index) => 'assets/workout_icons/typeL$index.png',
  );

  final List<String> categories = [
    "Back  ",
    "Biceps  ",
    "Chest  ",
    'Triceps  ',
    "ABS  ",
    "Legs  ",
    "Shoulders  ",
    'Stretching  ',
    'Other  '
  ];

  bool _isLoading = true;

  late List<String> groups;

  void initializeData() {
    check_applic = true;
    selectedImage = 'assets/workout_icons/typeL0.png';
    selectedImageIndex = 0;
    selectedCategory = "Back  ";
  }

  void loadData() {
    selectedImage = removeL(widget.exercise!.iconPath);
    selectedImageIndex = getImageIndex(selectedImage);
    name_tec.text = widget.exercise!.name;
    selectedCategory = widget.exercise!.type;
    check_applic = widget.exercise!.application == 0 ? false : true;
    msc.setOptions(_mapGroupsToValueItems(groups));
    msc.setSelectedOptions(_mapGroupsToValueItems(widget.exercise!.groupName));
    desc_tec.text = widget.exercise!.description;
  }

  Future<void> _loadGroups() async {
    List<Groups> groupList = await DatabaseHelper().getGroups();
    setState(() {
      groups = groupList.map((group) => group.name).toList(); // Assuming Groups has a 'name' property
      groups.add("None");
      _isLoading = false;
    });
  }

  List<ValueItem> _mapGroupsToValueItems(List<String> groups) {
    return groups.map((group) => ValueItem(label: group, value: group)).toList();
  }

  List<String> _valueItemsToStringList(List<ValueItem> selectedGroups) {
    List<String> sg = [];
    for (int i = 0; i < selectedGroups.length; i++) {
      sg.add(selectedGroups.elementAt(i).label.toString());
    }
    return sg;
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
        groupName: _valueItemsToStringList(msc.selectedOptions),
        description: desc_tec.text,
      );
      await DatabaseHelper().updateExercise(exercise);
    } else {
      Exercise exercise = Exercise(
        name: name_tec.text,
        type: selectedCategory,
        application: check_applic ? 1 : 0,
        iconPath: images[selectedImageIndex],
        groupName: _valueItemsToStringList(msc.selectedOptions),
        description: desc_tec.text,
      );
      await DatabaseHelper().insertExercise(exercise);
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
    _loadGroups().then((value) {
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            items: categories.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(
                                  category,
                                  style: TextStyle(fontSize: 20),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                              });
                            },
                          ),
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
                        chipConfig: const ChipConfig(wrapType: WrapType.wrap,backgroundColor: Color(0xFF2A8CBB)),
                        dropdownHeight: 300,
                        optionTextStyle: const TextStyle(fontSize: 16),
                        selectedOptionIcon: const Icon(Icons.check_circle,color: Color(0xFF2A8CBB),),
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
                        height: 100, // Wysokość kontenera dla 4 linii tekstu
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: desc_tec,
                          maxLines: 4, // Ustawienie maksymalnej liczby linii
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
                  if (name_tec.text.isNotEmpty && msc.selectedOptions.isNotEmpty) {
                    await addExercise();
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  } else {
                    const snackBar = SnackBar(
                      content: Text(
                        'Do not forget about name and groups!',
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
