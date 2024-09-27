import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/Begin/AcceptGroup.dart';
import '../../../Controllers/GroupsController.dart';
import '../../../database_classes/DatabaseHelper.dart';
import '../../../database_classes/Exercise.dart';
import '../../../database_classes/Group.dart';

class PickGroupGroups extends StatefulWidget {
  final Iterable<int>? editables;
  const PickGroupGroups({super.key, this.editables});

  @override
  State<PickGroupGroups> createState() => _PickGroupGroupsState();
}

class _PickGroupGroupsState extends State<PickGroupGroups> {
  List<int> selectedExercises = []; // Przechowywanie ID wybranych ćwiczeń
  Map<int, bool> expandedGroups = {}; // Zaznaczenie, które grupy są rozwinięte
  List<Groups> groups = []; // Przechowywanie załadowanych grup
  bool isLoading = true; // Flaga ładowania

  @override
  void initState() {
    super.initState();
    _initiateSelectedExercises();
    _loadGroups(); // Ładowanie grup przy inicjalizacji
  }

  void _initiateSelectedExercises() {
    if (widget.editables != null) {
      for (int i in widget.editables!) {
        selectedExercises.add(i);
      }
    }
  }

  int getSelectedExercisesCountForGroup(Groups group) {
    return group.exercises.where((exercise) => selectedExercises.contains(exercise.id)).length;
  }

  void clear_selected(){
    selectedExercises.clear();
  }

  Future<void> _loadGroups() async {
    setState(() {
      isLoading = true; // Ustaw flagę ładowania
    });

    // Pobierz dane z GroupsManager
    await GroupsManager.gManager.initiateOrClearGroups(null, "A-Z");
    List<Groups> loadedGroups = await GroupsManager.gManager.groups;

    // Usuń grupy, których pole 'exercises' jest puste
    List<Groups> filteredGroups = loadedGroups.where((group) => group.exercises.isNotEmpty).toList();

    setState(() {
      groups = filteredGroups; // Przypisz przefiltrowane grupy
      isLoading = false; // Wyłącz flagę ładowania
    });
  }


  void _onExerciseChecked(int exerciseId, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!selectedExercises.contains(exerciseId)) {
          selectedExercises.add(exerciseId); // Dodaj, jeśli nie ma na liście
        }
      } else {
        selectedExercises.remove(exerciseId); // Usuń, jeśli jest odznaczony
      }
    });
  }

  void _toggleGroupExpansion(int groupId) {
    setState(() {
      expandedGroups[groupId] = !(expandedGroups[groupId] ?? false);
    });
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
                padding: EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                child: Text(
                  "Select groups and exercises",
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator()) // Pokaż loader, gdy dane są ładowane
                  : ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  Groups group = groups[index];
                  bool isExpanded = expandedGroups[group.id] ?? false;
                  int nofSelected = getSelectedExercisesCountForGroup(group);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Card(
                      color: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _toggleGroupExpansion(group.id!);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  // Leading (Image)
                                  Image.asset(
                                    group.iconPath,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 20), // Dodaj odstęp między obrazkiem a tekstem
                                  // Title and Subtitle (Group Name and Exercises Info)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          group.name,
                                          style: const TextStyle(fontSize: 23),
                                        ),
                                        const SizedBox(height: 12), // Dodaj odstęp między nazwą grupy a liczbą ćwiczeń
                                        Text(
                                          "${group.exercises.length} exercises",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(height: 4), // Dodaj odstęp między liczbą ćwiczeń a zaznaczonymi
                                        Text(
                                          nofSelected > 0 ?
                                          "${nofSelected} selected"
                                          : "None selected",
                                          style: const TextStyle(fontSize: 18, color: Color(0xFF2A8CBB),), // Zmieniony kolor tekstu
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Trailing (Icon)
                                  Icon(
                                    isExpanded ? Icons.expand_less : Icons.expand_more,
                                    size: 28, // Ustaw rozmiar ikony
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if(group.exercises.isNotEmpty)
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 300), // Animowane przełączanie
                              reverseDuration: Duration(milliseconds: 300),
                              child: isExpanded
                                  ? Column(
                                key: ValueKey(group.id), // Klucz do rozpoznania unikalnego elementu
                                children: [
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Column(
                                      children: group.exercises.map((exercise) {
                                        return CheckboxListTile(
                                          activeColor: const Color(0xFF2A8CBB),
                                          value: selectedExercises.contains(exercise.id),
                                          title: Text(exercise.name,style: TextStyle(fontSize: 18),),
                                          onChanged: (bool? value) {
                                            _onExerciseChecked(exercise.id!, value!);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )
                                  : SizedBox.shrink(),
                            ),
                        ],
                      ),
                    ),
                  );
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
                  if(selectedExercises.isNotEmpty){
                    List<Exercise> exercises = await DatabaseHelper().getExercisesByIds(selectedExercises);
                    Groups ot_group = Groups(name: "Temporary group",
                        iconPath: 'assets/group_icons/typeL0.png', exercises: exercises);
                    if(context.mounted){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AcceptGroup(
                              selectedGroup: ot_group,)), // Trzecia klasa przekierowująca
                      );
                    }
                  }
                  else{
                    const snackBar = SnackBar(
                      content: Text(
                        'You need to pick at least 1 exercise!!',
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
        ),
      ),
    );
  }
}
