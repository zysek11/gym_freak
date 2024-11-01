import 'package:flutter/material.dart';
import 'package:gym_freak/database_classes/Exercise.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import '../../../Controllers/ExerciseTypesManager.dart';
import '../../../database_classes/DatabaseHelper.dart';
import '../../../database_classes/Group.dart';
import '../Workout/Begin/AcceptGroup.dart';

class PickGroupExercises extends StatefulWidget {
  final Iterable<int>? editables;
  final bool oneTimeW;

  PickGroupExercises({super.key, required this.oneTimeW, this.editables});

  @override
  State<PickGroupExercises> createState() => _PickGroupExercisesState();
}

class _PickGroupExercisesState extends State<PickGroupExercises> {
  late Future<List<Exercise>> _exercisesFuture;
  List<Exercise> allExercises = [];
  List<Exercise> filteredExercises = [];
  Map<int, int> selectedExercises = {}; // Zaznaczone ćwiczenia
  List<Map<String, dynamic>> categories = [];
  List<String> pickedCategories = []; // Wybrane kategorie

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _fetchExercises();
    _loadExerciseCategories();
  }

  Future<List<Exercise>> _fetchExercises() async {
    allExercises = await DatabaseHelper().getExercises();
    // Inicjalizacja ćwiczeń i kategorii na podstawie editables
    if (widget.editables != null) {
      // Przypisanie zaznaczonych ćwiczeń do selectedExercises i pickedCategories
      selectedExercises = {
        for (var id in widget.editables!) id: id,
      };
      pickedCategories = await _initializePickedCategories();
      _filterExercises(pickedCategories);
    } else {
      // Jeśli brak wstępnie zaznaczonych, pokaż wszystkie ćwiczenia
      filteredExercises = allExercises;
    }
    return allExercises;
  }

  Future<List<String>> _initializePickedCategories() async {
    // Pobranie kategorii ćwiczeń na podstawie ID z editables
    return await DatabaseHelper().getExerciseTypesByIds(widget.editables!.toList());
  }

  void _loadExerciseCategories() {
    categories = ExerciseTypesManager().allExercises;
  }

  void _filterExercises(List<String> selectedCategories) {
    setState(() {
      if (selectedCategories.isEmpty) {
        filteredExercises = allExercises; // Pokaż wszystkie ćwiczenia, jeśli brak wyboru
      } else {
        // Filtruj ćwiczenia na podstawie wybranych kategorii
        filteredExercises = allExercises.where((exercise) {
          return selectedCategories.contains(exercise.type);
        }).toList();
      }
    });
  }

  void _onCheckboxChanged(int exerciseId) {
    setState(() {
      if (selectedExercises.containsKey(exerciseId)) {
        selectedExercises.remove(exerciseId); // Usuń zaznaczenie
      } else {
        selectedExercises[exerciseId] = exerciseId; // Dodaj zaznaczenie
      }
    });
  }

  List<ValueItem> _mapCategoriesToValueItems() {
    return categories
        .map((category) => ValueItem(label: category['name'], value: category['name']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<Exercise>>(
          future: _exercisesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Ładowanie
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading exercises: ${snapshot.error}')); // Obsługa błędów
            } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Select exercises",
                      style: TextStyle(color: Colors.black, fontSize: 26),
                    ),
                  ),
                  MultiSelectDropDown(
                    onOptionSelected: (selectedOptions) {
                      pickedCategories = selectedOptions.map((item) => item.label).toList();
                      _filterExercises(pickedCategories);
                    },
                    options: _mapCategoriesToValueItems(),
                    selectedOptions: pickedCategories
                        .map((category) => ValueItem(label: category, value: category))
                        .toList(),
                    maxItems: categories.length,
                    selectionType: SelectionType.multi,
                    chipConfig: const ChipConfig(
                      wrapType: WrapType.wrap,
                      backgroundColor: Color(0xFF2A8CBB),
                    ),
                    dropdownHeight: 300,
                    selectedOptionTextColor: Color(0xFF2A8CBB),
                    optionTextStyle: const TextStyle(fontSize: 16),
                    selectedOptionIcon: const Icon(Icons.check_circle),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 6 / 5,
                      ),
                      itemCount: filteredExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = filteredExercises[index];
                        final isSelected = selectedExercises.containsKey(exercise.id);
                        return GestureDetector(
                          onTap: () {
                            _onCheckboxChanged(exercise.id!);
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF2A8CBB),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: Color(0xFF2A8CBB), width: 1),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedExercises.clear();
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
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 6, bottom: 12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF2A8CBB),
                        backgroundColor: Color(0xFF2A8CBB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (selectedExercises.isNotEmpty) {
                          List<Exercise> selectedExercisesList = allExercises
                              .where((exercise) => selectedExercises.values.contains(exercise.id))
                              .toList();
                          if (widget.oneTimeW == false) {
                            Navigator.pop(context, selectedExercisesList);
                          } else {
                            Groups ot_group = Groups(
                              name: "Temporary group",
                              iconPath: 'assets/group_icons/typeL0.png',
                              exercises: selectedExercisesList,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AcceptGroup(selectedGroup: ot_group),
                              ),
                            );
                          }
                        } else {
                          const snackBar = SnackBar(
                            content: Text(
                              'You need to pick at least 1 exercise!',
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
              );
            }
          },
        ),
      ),
    );
  }
}