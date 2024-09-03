import 'package:flutter/cupertino.dart';

import '../database_classes/DatabaseHelper.dart';
import '../database_classes/Group.dart';

class GroupsManager extends ChangeNotifier{
  GroupsManager._privateConstructor();
  static final GroupsManager _gManager = GroupsManager._privateConstructor();
  static GroupsManager get gManager => _gManager;

  Future<List<Groups>> _groups = Future.value([]);

  Future<List<Groups>> get groups {
    return _groups;
  }

  void assignData(List<Groups> gr) {
    _groups = Future.value(gr);
    notifyListeners();
  }

  Future<void> initiateOrClearGroups(String? tecSearch) async {
    List<Groups> groups = await DatabaseHelper().getGroups();
    if (tecSearch != null && tecSearch.isNotEmpty) {
      filterGroups(tecSearch);
    } else {
      assignData(groups);
    }
  }

  void sortGroups(String selectedOption) async {
    List<Groups> groups = await this.groups;
    switch (selectedOption) {
      case "A-Z":
        groups.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Z-A":
        groups.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
    assignData(groups);
  }

  Future<void> filterGroups(String tecSearch) async {
    List<Groups> groups = await this.groups;
    List<Groups> filteredGroups = groups.where((group) {
      return group.name.contains(tecSearch);
    }).toList();
    assignData(filteredGroups);
  }

  Future<void> removeGroup(int id) async {
    await DatabaseHelper().deleteGroup(id);
    initiateOrClearGroups(null);
  }

  Future<void> addGroup(Groups group) async {
    await DatabaseHelper().insertGroup(group);
    initiateOrClearGroups(null);
  }

}
