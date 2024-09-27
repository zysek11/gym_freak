import 'package:flutter/material.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/Group.dart';
import '../../../../../database_classes/Exercise.dart';

class PickExerciseScreen extends StatefulWidget {
  final Groups group;
  final int exerciseNumber;
  final List<int> asList;
  final int series;

  const PickExerciseScreen({
    super.key,
    required this.group,
    required this.exerciseNumber,
    required this.asList,
    required this.series,
  });

  @override
  State<PickExerciseScreen> createState() => _PickExerciseScreenState();
}

class _PickExerciseScreenState extends State<PickExerciseScreen> {
  int? selectedExerciseIndex; // Przechowuje zaznaczone ćwiczenie

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A8CBB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "PICK EXERCISE",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: 'Jaapokki',
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Center(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Dwa elementy w rzędzie
                      mainAxisSpacing: 15, // Odstęp pionowy
                      crossAxisSpacing: 15, // Odstęp poziomy
                      childAspectRatio: 0.8, // Stosunek szerokości do wysokości
                    ),
                    itemCount: widget.group.exercises.length, // Liczba ćwiczeń
                    itemBuilder: (context, index) {
                      Exercise exercise = widget.group.exercises[index];
                      bool isSelected = selectedExerciseIndex == index;
                      bool isDisabled = widget.asList.contains(index); // Sprawdza, czy ćwiczenie jest już wybrane

                      return GestureDetector(
                        onTap: isDisabled
                            ? null // Jeśli jest już wybrane, ignoruj naciśnięcia
                            : () {
                          setState(() {
                            selectedExerciseIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDisabled
                                ? Colors.grey.shade400 // Jeśli ćwiczenie jest wybrane, wyświetl na szaro
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ?  Colors.black  :const Color(0xFF2A8CBB),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Nazwa ćwiczenia
                                Text(
                                  exercise.name,
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: isDisabled ? Colors.grey.shade700 : Colors.black,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2, // Ograniczenie linii tekstu
                                  overflow: TextOverflow.ellipsis, // Skondensowanie tekstu, gdy za długi
                                ),
                                const Spacer(),
                                // Ikona ćwiczenia (jeśli jest dostępna)
                                Image.asset(
                                  exercise.iconPath,
                                ),
                                const Spacer(),
                                // Typ ćwiczenia
                                Text(
                                  exercise.type, // Wyświetl typ ćwiczenia
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isDisabled ? Colors.grey.shade700 : Colors.black,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                // Checkbox
                                Checkbox(
                                  value: isSelected,
                                  onChanged: isDisabled
                                      ? null // Nie pozwala zmienić, jeśli wyłączone
                                      : (bool? value) {
                                    setState(() {
                                      selectedExerciseIndex = index;
                                    });
                                  },
                                  activeColor: const Color(0xFF2A8CBB),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF2A8CBB),
                  backgroundColor: Colors.white,
                  // button text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    // button border radius
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
                onPressed: (){
                  if(selectedExerciseIndex != null){
                    TrainingManager.tManager.setExercise(selectedExerciseIndex!);
                    TrainingManager.tManager.actualState = TrainingState.e_before;
                  }
                  else{
                    const snackBar = SnackBar(
                      content: Text(
                        'Pick exercise first!',
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color(0xFFFFFFFF),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
