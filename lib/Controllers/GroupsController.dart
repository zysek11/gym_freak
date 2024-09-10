import 'package:flutter/material.dart';
import '../database_classes/DatabaseHelper.dart';
import '../database_classes/Group.dart';

class GroupsManager extends ChangeNotifier {
  GroupsManager._privateConstructor();
  static final GroupsManager _gManager = GroupsManager._privateConstructor();
  static GroupsManager get gManager => _gManager;

  Future<List<Groups>> _groups = Future.value([]);

  Future<List<Groups>> get groups {
    return _groups;
  }

  // Funkcja odświeżająca dane z bazy
  Future<void> refresh() async {
    List<Groups> groups = await DatabaseHelper().getGroups();
    assignData(groups);  // Aktualizuje grupy
  }

  // Funkcja przypisująca dane i powiadamiająca listenerów
  void assignData(List<Groups> gr) {
    _groups = Future.value(gr);
    notifyListeners();
  }

  // Funkcja sortująca dane bez ich odświeżania
  void sortGroups(String selectedOption) async {
    List<Groups> groups = await this.groups; // Używa już załadowanych danych
    switch (selectedOption) {
      case "A-Z":
        groups.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Z-A":
        groups.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
    assignData(groups);  // Przypisuje posortowane dane
  }

  // Funkcja filtrująca, która najpierw odświeża, potem sortuje i filtruje dane
  Future<void> filterGroups(String tecSearch, String selectedOption) async {
    // Odśwież dane
    await refresh();

    // Sortuj dane
    sortGroups(selectedOption);

    // Pobierz posortowane dane i zastosuj filtr
    List<Groups> groups = await this.groups;
    List<Groups> filteredGroups = groups.where((group) {
      return group.name.contains(tecSearch);
    }).toList();

    assignData(filteredGroups);  // Przypisuje przefiltrowane dane
  }

  // Funkcja do inicjacji lub czyszczenia listy grup
  Future<void> initiateOrClearGroups(String? tecSearch, String selectedOption) async {
    if (tecSearch != null && tecSearch.isNotEmpty) {
      await filterGroups(tecSearch, selectedOption);
    } else {
      await refresh();
      sortGroups(selectedOption);  // Sortuj dane, jeśli nie ma wyszukiwania
    }
  }

  // Funkcja usuwająca grupę i odświeżająca listę grup
  Future<void> removeGroup(int id) async {
    await DatabaseHelper().deleteGroup(id);
    await refresh();  // Odśwież dane po usunięciu
  }

  // Funkcja dodająca grupę i odświeżająca listę grup
  Future<void> addGroup(Groups group) async {
    await DatabaseHelper().insertGroup(group);
    await refresh();  // Odśwież dane po dodaniu nowej grupy
  }
}
