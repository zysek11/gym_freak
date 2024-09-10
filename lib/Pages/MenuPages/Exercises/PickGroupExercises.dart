import 'package:flutter/material.dart';
import 'package:gym_freak/database_classes/Exercise.dart';
import 'package:gym_freak/database_classes/Group.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import '../../../database_classes/DatabaseHelper.dart';

class PickGroupExercises extends StatefulWidget {
  final Iterable<int>? editables;
  bool oneTimeW;
  PickGroupExercises({super.key, required this.oneTimeW, this.editables});

  @override
  State<PickGroupExercises> createState() => _PickGroupExercisesState();
}

class _PickGroupExercisesState extends State<PickGroupExercises> {
  late Future<List<Exercise>> exercisesFuture;
  late Future<List<Exercise>> exercisesFutureSorted;
  Map<int, int> selectedExercises = {};
  MultiSelectController msc = MultiSelectController();

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

  List<String> picked_categories = [
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

  @override
  void initState() {
    super.initState();
    _initiateSelectedExercises();
    _loadExercises();
  }

  void clear_selected(){
    selectedExercises.clear();
  }

  void _loadExercises() async {
    exercisesFuture = DatabaseHelper().getExercises();
    exercisesFutureSorted = sortExercises(categories);
  }

  Future<List<Exercise>> sortExercises(List<String> categories) async {
    List<Exercise> allExercises = await exercisesFuture;
    List<Exercise> filteredExercises = allExercises.where((exercise) {
      return categories.contains(exercise.type);
    }).toList();
    return filteredExercises;
  }

  void _onCheckboxChanged(int index, int v_value) {
    setState(() {
      if(selectedExercises.containsValue(v_value)){
        selectedExercises.removeWhere((key, value) => v_value == value);
      }
      else{
        selectedExercises[v_value] = v_value;
      }
    });
  }

  void _initiateSelectedExercises() {
    if (widget.editables != null) {
      for (int id in widget.editables!) {
        selectedExercises[id] = id;
      }
    }
  }

  List<ValueItem> _mapCategoriesToValueItems() {
    return categories.map((category) => ValueItem(label: category, value: category)).toList();
  }

  List<ValueItem> _mapSelectedCategoriesToValueItems() {
    return picked_categories.map((category) => ValueItem(label: category, value: category)).toList();
  }

  List<String> _valueItemsToStringList(List<ValueItem> selectedTypes) {
    List<String> sg = [];
    for (int i = 0; i < selectedTypes.length; i++) {
      sg.add(selectedTypes.elementAt(i).label.toString());
    }
    return sg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Select exercises",
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
              ),
            ),
            MultiSelectDropDown(
              controller: msc,
              onOptionSelected: (options) {
                picked_categories = _valueItemsToStringList(options);
                setState(() {
                  exercisesFutureSorted = sortExercises(picked_categories);
                });
              },
              options: _mapCategoriesToValueItems(),

              selectedOptions: _mapSelectedCategoriesToValueItems(),
              maxItems: categories.length,
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap,backgroundColor: Color(0xFF2A8CBB) ),
              dropdownHeight: 300,
              selectedOptionTextColor: Color(0xFF2A8CBB),
              optionTextStyle: const TextStyle(fontSize: 16,),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            Expanded(
              child: FutureBuilder<List<Exercise>>(
                future: exercisesFutureSorted,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No exercises found.'));
                  } else {
                    List<Exercise> exercises = snapshot.data!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 6 / 5,
                      ),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        Exercise exercise = exercises[index];
                        bool isSelected = selectedExercises.containsValue(exercise.id);
                        return GestureDetector(
                          onTap: () {
                            _onCheckboxChanged(index, exercise.id!);
                          },
                          child: Card(
                            color: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        exercise.iconPath,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      ),
                                      Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected
                                                ? Color(0xFF2A8CBB)
                                                : Colors.black,
                                            width: 1,
                                          ),
                                          color: isSelected
                                              ? Color(0xFF2A8CBB)
                                              : Colors.transparent,
                                        ),
                                        width: 32,
                                        height: 32,
                                        child: isSelected
                                            ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 18),
                                  Text(
                                    exercise.name,
                                    style: TextStyle(
                                      fontSize: 21,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    exercise.type,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF2A8CBB),
                                    ),
                                  ),
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
            Padding(
              padding: const EdgeInsets.only(left: 18,right: 18,top: 12,bottom: 6),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF2A8CBB),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: BorderSide(color: Color(0xFF2A8CBB), width: 1),
                ),
                onPressed: () async {
                  setState(() {
                    clear_selected();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "CLEAR ALL",
                        style: TextStyle(
                          color: Color(0xFF2A8CBB),
                          fontSize: 22,
                          fontFamily: 'Jaapokki',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18,right: 18,top: 6,bottom: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF2A8CBB),
                  backgroundColor: Color(0xFF2A8CBB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  List<Exercise> allExercises = await exercisesFuture;
                  List<Exercise> selectedExercisesList = allExercises
                      .where((exercise) => selectedExercises.values.contains(exercise.id))
                      .toList();
                  if(widget.oneTimeW == false){
                    Navigator.pop(context, selectedExercisesList);
                  }
                  else{
                    Groups ot_group = Groups(name: "Temporary group",
                        iconPath: 'assets/group_icons/typeL0.png', exercises: selectedExercisesList);
                    Navigator.pop(context, ot_group);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "ALL SELECTED",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
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
