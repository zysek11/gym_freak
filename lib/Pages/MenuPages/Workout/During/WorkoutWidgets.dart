import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../database_classes/Group.dart';
import 'Screens/AfterScreen.dart';
import 'Screens/BeforeScreen.dart';
import 'Screens/CleanScreen.dart';
import 'Screens/DuringScreen.dart';
import 'Screens/RatingScreen.dart';
import 'Screens/SummaryScreen.dart';

class WorkoutWidgets extends StatefulWidget {
  final Groups pg;
  final bool type;
  const WorkoutWidgets({super.key,  required this.pg,  required this.type});

  @override
  State<WorkoutWidgets> createState() => _WorkoutWidgetsState();
}

class _WorkoutWidgetsState extends State<WorkoutWidgets> {

  @override
  void initState() {
    TrainingManager.tManager.actualState = widget.type ? TrainingState.e_before : TrainingState.clean;
    TrainingManager.tManager.setOrResetData(widget.pg);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TrainingState>(
      stream: TrainingManager.tManager.stateStream, // Zakładam, że masz strumień aktualizujący stan
      initialData: TrainingManager.tManager.actualState,
      builder: (context, snapshot) {
        return TrainingManager.tManager.workoutController.loadWindow(snapshot.data!)!;
      },
    );
  }
}

class WidgetController {

  // Deklaracja właściwości `actualWindow` jako `Widget?`, aby mogła przyjąć wartość `null` początkowo.
  Widget? actualWindow;

  void setActualWindow(Widget newWindow) {
    actualWindow = newWindow;
  }

  // Przykładowa metoda do pobierania aktualnego widżetu
  Widget? getActualWindow() {
    return actualWindow;
  }

  Widget getBeforeExerciseScreen() {
    return BeforeExerciseScreen(
      group: TrainingManager.tManager.selectedGroup,
      exerciseNumber: TrainingManager.tManager.exerciseNumber,
      series: TrainingManager.tManager.series,
    );
  }

  Widget getDuringExerciseScreen() {
    return DuringExerciseScreen(
      group: TrainingManager.tManager.selectedGroup,
      exerciseNumber: TrainingManager.tManager.exerciseNumber,
      series: TrainingManager.tManager.series,
    );
  }

  Widget getAfterExerciseScreen() {
    return AfterExerciseScreen(
      group: TrainingManager.tManager.selectedGroup,
      exerciseNumber: TrainingManager.tManager.exerciseNumber,
      series: TrainingManager.tManager.series,
    );
  }

  Widget getCleanExercisesScreen() {
    return CleanExercisesScreen();
  }

  Widget getSummaryExerciseScreen() {
    return SummaryExerciseScreen();
  }

  Widget getRatingExercisesScreen() {
    return RatingExercisesScreen();
  }
}

// button

class TrainingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const TrainingButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF2A8CBB),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.black),
              if (icon != null) SizedBox(width: 10), // Dodaj odstęp, jeśli jest ikona
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'Jaapokki',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
