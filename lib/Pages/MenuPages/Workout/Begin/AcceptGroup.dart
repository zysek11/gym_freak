import 'package:flutter/material.dart';
import '../../../../database_classes/Exercise.dart';
import '../../../../database_classes/Group.dart';
import 'PickType.dart';

class AcceptGroup extends StatefulWidget {
  final Groups selectedGroup;
  const AcceptGroup({super.key, required this.selectedGroup});

  @override
  State<AcceptGroup> createState() => _AcceptGroupState();
}

class _AcceptGroupState extends State<AcceptGroup> {
  late Groups pickedGroup;

  String removeL(String input) {
    return input.replaceAll(RegExp('[Ll]'), '');
  }

  @override
  void initState() {
    pickedGroup = widget.selectedGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A8CBB),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Nagłówek
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                child: Text(
                  "SELECTED WORKOUT",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Jaapokki',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Spacer(),
            // Główna sekcja
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(width: 2, color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Kontener nie będzie się rozszerzał niepotrzebnie
                  children: [
                    // Nazwa grupy na środku
                    Center(
                      child: Text(
                        pickedGroup.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lato',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Obrazek na środku
                    Center(
                      child: Image.asset(
                        removeL(pickedGroup.iconPath),
                        width: 128,
                        height: 128,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Informacja o czasie trwania
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/clock.png",
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "30-40 min",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Informacja o liczbie ćwiczeń
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icons/weights.png",
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          pickedGroup.exercises.length == 1
                              ? "${pickedGroup.exercises.length} exercise"
                              : "${pickedGroup.exercises.length} exercises",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Lista ćwiczeń z limitem wysokości i możliwością przewijania
                    if (pickedGroup.exercises.isNotEmpty)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 275, // Maksymalna wysokość listy ćwiczeń
                        ),
                        child: ListView.builder(
                          shrinkWrap: true, // Lista dostosowuje się do zawartości
                          itemCount: pickedGroup.exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = pickedGroup.exercises[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Exercise ${index + 1}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Color(0xFF2A8CBB)),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    exercise.name,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF2A8CBB),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PickType(pg: pickedGroup),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          'NEXT STEP',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Jaapokki',
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/icons/right_arrow.png',
                        width: 30,
                        fit: BoxFit.cover,
                        color: Colors.black,
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
