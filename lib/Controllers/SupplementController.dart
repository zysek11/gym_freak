import 'package:flutter/material.dart';
import 'package:gym_freak/database_classes/Supplement.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database_classes/DatabaseHelper.dart';

class SupplementManager extends ChangeNotifier {
  SupplementManager._privateConstructor();
  static final SupplementManager _sManager = SupplementManager._privateConstructor();
  static SupplementManager get sManager => _sManager;

  List<Supplement> _supplements = [];

  List<Supplement> get supplements => _supplements;

  Future<void> getSupplements() async {
    _supplements = await DatabaseHelper().getLatestSupplementsByProfile(1);
    notifyListeners();
  }


  Future<bool> addSupplement(String name, double value, String unit, DateTime selectedDate,
      DateTime endDate, bool indefinite, bool counting, int times, int status, String? description) async {
    bool validation = await DatabaseHelper().checkSupplementByName(name.toUpperCase());
    if(validation == false){
      return false;
    }
    final newSupplement = Supplement(
      name: name.toUpperCase(),
      value: value,
      definiteFlag: !indefinite ? 1 : 0,
      dateOfStart: DateFormat('yyyy-MM-dd').format(selectedDate),
      dateOfEnd: !indefinite ? DateFormat('yyyy-MM-dd').format(endDate): null,
      todayFlag: 0,
      checkCounterFlag: counting ? 1 : 0,
      counter: counting ? 0 : null,
      suppLimit: counting ? times : null,
      profileId: 1,
      description: description,
      unit: unit,
      status: status,

    );
    await DatabaseHelper().insertSupplement(newSupplement);
    await getSupplements(); // Refresh list after adding
    return true;
  }

  Future<void> updateSupplement(Supplement supplement) async {
    await DatabaseHelper().updateSupplement(supplement);
    final index = _supplements.indexWhere((s) => s.id == supplement.id);
    if (index != -1) {
      _supplements[index] = supplement;
      notifyListeners(); // Trigger update
      print("Updated supplement: ${_supplements[index].name}"); // Debugging line
    }
  }


  // Funkcja usuwająca ćwiczenie i odświeżająca listę ćwiczeń
  Future<void> removeSupplement(int id) async {
    await DatabaseHelper().deleteSupplement(id);
    await getSupplements();  // Odśwież dane po usunięciu
  }

  Future<void> checkAndUpdateTodayData() async {
    // Pobierz instancję SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Pobierz dzisiejszą datę jako string w formacie 'yyyy-MM-dd'
    final String todayString = DateTime.now().toIso8601String().split('T')[0];

    // Odczytaj wartość todayData z SharedPreferences
    final storedDate = prefs.getString('todayData');

    // Sprawdź, czy przechowywana data jest null lub różni się od dzisiejszej
    if (storedDate == null || storedDate != todayString) {
      // Jeśli data jest inna lub brak zapisanej daty, zaktualizuj todayData na dzisiejszą datę
      await prefs.setString('todayData', todayString);

      // Wykonaj tutaj operacje, które chcesz wykonać przy nowej dacie
      performSomeOperations(todayString);
    } else {
      // Jeśli data się zgadza, wykonaj inne operacje, jeśli potrzebne
      print("Dzisiaj jest już zapisane w pamięci.");
    }
  }

  Future<void> performSomeOperations(String todayDate) async {
    await DatabaseHelper().resetTodayInSupplements();
    await DatabaseHelper().checkStatusInSupplements(todayDate);
  }



}

