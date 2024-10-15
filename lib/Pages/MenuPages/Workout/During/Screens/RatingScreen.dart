import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gym_freak/Managers/TrainingManager.dart';
import '../../../../../database_classes/DatabaseHelper.dart';
import '../../../../../database_classes/Workout.dart';
import '../WorkoutWidgets.dart';

class RatingExercisesScreen extends StatefulWidget {
  const RatingExercisesScreen({Key? key}) : super(key: key);

  @override
  _RatingExercisesScreenState createState() => _RatingExercisesScreenState();
}

class _RatingExercisesScreenState extends State<RatingExercisesScreen> {

  TextEditingController comment = TextEditingController();
  double? rating_intensity;
  double? rating_satisfaction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Postać (obrazek) na górze
              Image.asset(
                'assets/gymmy/2nd.png', // Zastąp swoim obrazem
                height: 205,
              ),
              const SizedBox(height: 25),
              const Text(
                'Rate your intensity:',
                style: TextStyle(
                  fontSize: 21,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 25),
              // Ocena intensywności (gwiazdki)
              RatingBar(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                ratingWidget: RatingWidget(
                  full: Image.asset('assets/icons/kettlebell_full.png'),
                  half: Image.asset('assets/icons/kettlebell_half.png'),
                  empty: Image.asset('assets/icons/kettlebell_empty.png'),
                ),
                onRatingUpdate: (rating) {
                  rating_intensity = rating;
                },
              ),
              Spacer(),
              const Text(
                'Rate your satisfaction:',
                style: TextStyle(
                  fontSize: 21,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 25),
              // Ocena satysfakcji (gwiazdki)
              RatingBar(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                ratingWidget: RatingWidget(
                  full: Image.asset('assets/icons/kettlebell_full.png'),
                  half: Image.asset('assets/icons/kettlebell_half.png'),
                  empty: Image.asset('assets/icons/kettlebell_empty.png'),
                ),
                onRatingUpdate: (rating) {
                  rating_satisfaction = rating;
                },
              ),
              Spacer(),
              const Text(
                'New records, ups or downs?',
                style: TextStyle(
                  fontSize: 21,
                  fontFamily: 'Lato',
                ),
              ),
              const SizedBox(height: 25),
              // Pole tekstowe na uwagi
              Form(
                child: TextFormField(
                  controller: comment,
                  maxLines: 5,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Enter your notes here...', // Placeholder dla pola tekstowego
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5), // Jasne tło
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none, // Brak ramki, kiedy pole nie jest w edycji
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF2A8CBB), // Niebieska ramka podczas edytowania
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              // Przycisk "WORKOUT DONE"
              TrainingButton(
                text: 'WORKOUT DONE',
                onPressed: () async {
                  if(rating_intensity != null && rating_satisfaction != null && context.mounted){
                    Workout workout = Workout.full(exercises: TrainingManager.tManager.workoutController!.selectedWorkout.exercises,
                        date: TrainingManager.tManager.workoutController!.selectedWorkout.date,
                        intensity: rating_intensity!,
                        satisfaction: rating_satisfaction!,
                        comment: comment.text,
                        time: TrainingManager.tManager.returnFullTime());
                    await DatabaseHelper().insertWorkout(workout);
                    // wyczyszczenie danych treningu i zatrzymanie czasu
                    TrainingManager.tManager.cleanData();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                  else{
                    const snackBar = SnackBar(
                      content: Text(
                        'Remember to rate your training, comment is optional.',
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 2),
                      backgroundColor: Color(0xFFFFFFFF),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
