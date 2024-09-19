import 'package:flutter/material.dart';
import '../database_classes/DatabaseHelper.dart';
import '../database_classes/Exercise.dart';
import '../database_classes/Group.dart';

class ExercisesManager extends ChangeNotifier {
  ExercisesManager._privateConstructor();
  static final ExercisesManager _eManager = ExercisesManager._privateConstructor();
  static ExercisesManager get eManager => _eManager;

  Future<List<Exercise>> _exercises = Future.value([]);

  Future<List<Exercise>> get exercises {
    return _exercises;
  }

  Future<void> addGroupNamesToExercises(Iterable<int> exerciseIds, Groups group) async {
    // Pobierz wszystkie ćwiczenia z bazy danych
    List<Exercise> exercises = await DatabaseHelper().getExercises();

    // Iteruj przez każde ćwiczenie
    for (var exercise in exercises) {
      // Upewnij się, że lista groups nie jest null
      exercise.groups ??= [];

      // Sprawdź, czy ćwiczenie zawiera daną grupę
      bool containsGroup = exercise.groups!.any((g) => g.id == group.id);

      if (containsGroup) {
        // Jeśli ćwiczenie zawiera grupę, ale nie jest na liście exerciseIds, usuń grupę
        if (!exerciseIds.contains(exercise.id)) {
          exercise.groups!.removeWhere((g) => g.id == group.id);
          await DatabaseHelper().updateExercise(exercise);
        } else {
          // Jeśli ćwiczenie zawiera grupę i jest na liście exerciseIds, zaktualizuj grupę (jeśli potrzebne)
          int groupIndex = exercise.groups!.indexWhere((g) => g.id == group.id);
          if (groupIndex != -1) {
            exercise.groups![groupIndex] = group; // Aktualizujemy grupę
            await DatabaseHelper().updateExercise(exercise);
          }
        }
      } else {
        // Jeśli ćwiczenie nie zawiera grupy, ale jest na liście exerciseIds, dodaj grupę
        if (exerciseIds.contains(exercise.id)) {
          print("dodawanie id: " + group.id.toString());
          exercise.groups!.add(group);
          await DatabaseHelper().updateExercise(exercise);
        }
      }
    }

    // Odśwież dane (jeśli potrzebne do synchronizacji z widokiem)
    await refresh();
  }

  Future<void> removeGroupNamesFromExercises(int typeId) async {
    // Pobierz wszystkie ćwiczenia z bazy danych
    List<Exercise> exercises = await DatabaseHelper().getExercises();

    // Iteruj przez każde ćwiczenie
    for (var exercise in exercises) {
      // Upewnij się, że lista groups nie jest null
      if (exercise.groups != null && exercise.groups!.isNotEmpty) {
        // Sprawdź, czy ćwiczenie zawiera grupę
        bool containsGroup = exercise.groups!.any((g) => g.id == typeId);
        if (containsGroup) {
          // Usuń grupę
          exercise.groups!.removeWhere((g) => g.id == typeId);

          // Zaktualizuj ćwiczenie w bazie danych po usunięciu grupy
          await DatabaseHelper().updateExercise(exercise);
        }
      }
    }

    // Odśwież dane po usunięciu grup
    await refresh();
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
          (exercise.groups != null &&
              exercise.groups!.any((group) => group.name.contains(tecSearch)));
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
