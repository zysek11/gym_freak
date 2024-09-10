import 'package:flutter/material.dart';
import '../database_classes/DatabaseHelper.dart';
import '../database_classes/Exercise.dart';

class ExercisesManager extends ChangeNotifier {
  ExercisesManager._privateConstructor();
  static final ExercisesManager _eManager = ExercisesManager._privateConstructor();
  static ExercisesManager get eManager => _eManager;

  Future<List<Exercise>> _exercises = Future.value([]);

  Future<List<Exercise>> get exercises {
    return _exercises;
  }

  Future<void> addGroupNamesToExercises(Iterable<int> exerciseIds, String groupName) async {
    // Pobierz wszystkie ćwiczenia z bazy danych
    List<Exercise> exercises = await DatabaseHelper().getExercises();

    // Iteruj przez każde ćwiczenie
    for (var exercise in exercises) {
      // Sprawdź, czy ćwiczenie zawiera nazwę grupy
      if (exercise.groupName.contains(groupName)) {
        // Jeśli ćwiczenie zawiera nazwę grupy, ale nie jest na liście exerciseIds, usuń nazwę grupy
        if (!exerciseIds.contains(exercise.id)) {
          exercise.groupName.remove(groupName);
          // Zaktualizuj ćwiczenie w bazie danych
          await DatabaseHelper().updateExercise(exercise);
        }
      } else {
        // Jeśli ćwiczenie nie zawiera nazwy grupy, ale jest na liście exerciseIds, dodaj nazwę grupy
        if (exerciseIds.contains(exercise.id)) {
          exercise.groupName.add(groupName);
          // Zaktualizuj ćwiczenie w bazie danych
          await DatabaseHelper().updateExercise(exercise);
        }
      }
      await refresh();
    }
  }

  Future<void> removeGroupNamesFromExercises(String groupName) async {
    // Pobierz wszystkie ćwiczenia z bazy danych
    List<Exercise> exercises = await DatabaseHelper().getExercises();

    // Iteruj przez każde ćwiczenie
    for (var exercise in exercises) {
      // Sprawdź, czy ćwiczenie zawiera nazwę grupy
      if (exercise.groupName.contains(groupName)) {
        // Usuń nazwę grupy
        exercise.groupName.remove(groupName);

        // Zaktualizuj ćwiczenie w bazie danych
        await DatabaseHelper().updateExercise(exercise);
      }
    }
    refresh();
  }



  // Funkcja odświeżająca dane z bazy
  Future<void> refresh() async {
    List<Exercise> exercises = await DatabaseHelper().getExercises();
    assignData(exercises);  // Aktualizuje ćwiczenia
  }

  // Funkcja przypisująca dane i powiadamiająca listenerów
  void assignData(List<Exercise> ex) {
    _exercises = Future.value(ex);
    notifyListeners();
  }

  // Funkcja sortująca dane bez ich odświeżania
  void sortExercises(String selectedOption) async {
    List<Exercise> exercises = await this.exercises; // Używa już załadowanych danych
    switch (selectedOption) {
      case "A-Z":
        exercises.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Z-A":
        exercises.sort((a, b) => b.name.compareTo(a.name));
        break;
      case "By type":
        exercises.sort((a, b) => a.type.compareTo(b.type));
        break;
    }
    assignData(exercises);  // Przypisuje posortowane dane
  }

  // Funkcja filtrująca, która najpierw odświeża, potem sortuje i filtruje dane
  Future<void> filterExercises(String tecSearch, String selectedOption) async {
    // Odśwież dane
    await refresh();

    // Sortuj dane
    sortExercises(selectedOption);

    // Pobierz posortowane dane i zastosuj filtr
    List<Exercise> exercises = await this.exercises;
    List<Exercise> filteredExercises = exercises.where((exercise) {
      return exercise.name.contains(tecSearch) ||
          exercise.groupName.any((group) => group.contains(tecSearch));
    }).toList();

    assignData(filteredExercises);  // Przypisuje przefiltrowane dane
  }

  // Funkcja do inicjacji lub czyszczenia listy ćwiczeń
  Future<void> initiateOrClearExercises(String? tecSearch, String selectedOption) async {
    if (tecSearch != null && tecSearch.isNotEmpty) {
      await filterExercises(tecSearch, selectedOption);
    } else {
      await refresh();
      sortExercises(selectedOption);  // Sortuj dane, jeśli nie ma wyszukiwania
    }
  }

  // Funkcja usuwająca ćwiczenie i odświeżająca listę ćwiczeń
  Future<void> removeExercise(int id) async {
    await DatabaseHelper().deleteExercise(id);
    await refresh();  // Odśwież dane po usunięciu
  }
}
