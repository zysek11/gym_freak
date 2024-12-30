import 'package:flutter/material.dart';
import 'package:gym_freak/database_classes/ExerciseWrapper.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:provider/provider.dart';

import '../../Controllers/ExerciseTypesManager.dart';
import '../../Controllers/StatisticsController.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  TextEditingController tecSearch = TextEditingController();
  List<ExerciseWrapper> exercisesLimited = [];
  List<Map<String, dynamic>> categories = [];
  List<String> pickedCategories = []; // Wybrane kategorie
  Map<String,double> differencePower = {};

  /// Filters exercises by name and selected categories
  void _filterExercises(String query, List<String> selectedCategories) {
    final statsController =
    Provider.of<StatisticsController>(context, listen: false);
    final allExercises = statsController.exercises;

    // Filter by categories
    final filteredByCategory = selectedCategories.isEmpty
        ? allExercises
        : allExercises
        .where((exercise) =>
        selectedCategories.contains(exercise.exercise.type))
        .toList();

    // Further filter by name
    final filteredByName = query.isEmpty
        ? filteredByCategory
        : filteredByCategory
        .where((exercise) => exercise.exercise.name
        .toLowerCase()
        .contains(query.toLowerCase()))
        .toList();

    // Deduplicate and update state
    setState(() {
      exercisesLimited = removeDuplicates(filteredByName);
    });
  }

  /// Deduplicates exercises by name, keeping the one with the highest ID
  List<ExerciseWrapper> removeDuplicates(List<ExerciseWrapper> exercises) {
    final Map<String, ExerciseWrapper> uniqueExercises = {};
    for (var exercise in exercises) {
      if (!uniqueExercises.containsKey(exercise.exercise.name) ||
          (uniqueExercises[exercise.exercise.name]?.id ?? 0) <
              (exercise.id ?? 0)) {
        uniqueExercises[exercise.exercise.name] = exercise;
      }
    }
    return uniqueExercises.values.toList();
  }

  Widget buildCalculations(double difference){
    difference = ((difference * 10).roundToDouble()) / 10;
    if(difference == 9999){
      return Row(
        children: [
          Text("Not enough ", style: TextStyle(fontFamily: 'Lato', fontSize: 13,
              color: Colors.black, fontWeight: FontWeight.bold),),
          Image.asset('assets/icons/empty_progress.png',height: 18, width: 18,),
        ],
      );
    }
    else if(difference < 0.5 && difference > -0.5){
      return Row(
        children: [
          Text(difference.toString() + " % ", style: TextStyle(fontFamily: 'Lato', fontSize: 13,
              color: Colors.amber, fontWeight: FontWeight.bold,),),
          Image.asset('assets/icons/zero_progress.png',height: 18, width: 18,),
        ],
      );
    }
    else if(difference >= 0.5){
      return Row(
        children: [
          Text(difference.toString() + " % ", style: TextStyle(fontFamily: 'Lato', fontSize: 13,
              color: Colors.green, fontWeight: FontWeight.bold),),
          Image.asset('assets/icons/increase_progress.png',height: 18, width: 18,),
        ],
      );
    }
    else {
      return Row(
        children: [
          Text(difference.toString() + " % ", style: TextStyle(fontFamily: 'Lato', fontSize: 13,
              color: Colors.red, fontWeight: FontWeight.bold),),
          Image.asset('assets/icons/decrease_progress.png',height: 18, width: 18,),
        ],
      );
    }
  }

  void _loadExerciseCategories() {
    categories = ExerciseTypesManager().allExercises;
  }

  List<ValueItem> _mapCategoriesToValueItems() {
    return categories
        .map((category) => ValueItem(label: category['name'], value: category['name']))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadExerciseCategories();
    Future.microtask(() async {
      final statsController =
      Provider.of<StatisticsController>(context, listen: false);
      await statsController.getExercises();
      differencePower= statsController.calculatePowerPercentages();
      setState(() {
        exercisesLimited = removeDuplicates(statsController.exercises);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Exercises',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, bottom: 8, top: 16),
              child: TextFormField(
                controller: tecSearch,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Search exercise by name...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff2a8cbb)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                  suffixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  _filterExercises(value, pickedCategories);
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Filter by type',
              style: TextStyle(fontSize: 18, fontFamily: 'Lato', color: const Color(0xffBB592A)),
            ),
            const SizedBox(height: 10),
            // MultiSelectDropDown for Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75.0),
              child: MultiSelectDropDown(
                onOptionSelected: (selectedOptions) {
                  setState(() {
                    pickedCategories =
                        selectedOptions.map((item) => item.label).toList();
                  });
                  _filterExercises(tecSearch.text, pickedCategories);
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
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Exercises found:  ' + exercisesLimited.length.toString(),
                  style: TextStyle(fontSize: 18, fontFamily: 'Lato'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Exercise List
            Expanded(
              child: exercisesLimited.isEmpty
                  ? const Center(
                child: Text(
                  'No exercises found.',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: ListView.separated(
                      itemCount: exercisesLimited.length,
                      itemBuilder: (context, index) {
                        final ExerciseWrapper exercise = exercisesLimited[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF8F8F8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Image.asset(
                                    exercise.exercise.iconPath,
                                    width: 45,
                                    height: 45,
                                  ),
                                  SizedBox(width: 20), // Odstęp między obrazkiem a tekstem
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Wyrównanie tekstu do początku
                                    children: [
                                      Text(
                                        exercise.exercise.name,
                                        style: TextStyle(fontSize: 16, fontFamily: 'Lato'),
                                      ),
                                      SizedBox(height: 5,),
                                      Text(
                                        exercise.exercise.type,
                                        style: TextStyle(fontSize: 13, fontFamily: 'Lato',
                                        color: const Color(0xFF2A8CBB),),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(Icons.read_more,size: 25,color: Colors.black,)
                                ],
                              ),
                              if(exercise.exercise.application == 1)
                                ...[
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Actual power",
                                            style: TextStyle(fontSize: 13, fontFamily: 'Lato',
                                                color: const Color(0xFF2A8CBB), fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5,),
                                          buildCalculations(differencePower[exercise.exercise.name]!),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10), // Separator 10px
                    ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
