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
            const SizedBox(height: 20),
            // Exercise List
            Expanded(
              child: exercisesLimited.isEmpty
                  ? const Center(
                child: Text(
                  'No exercises found.',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ListView.builder(
                itemCount: exercisesLimited.length,
                itemBuilder: (context, index) {
                  final ExerciseWrapper exercise = exercisesLimited[index];
                  return ListTile(
                    title: Text(exercise.exercise.name),
                    subtitle: Text('Type: ${exercise.exercise.type}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
