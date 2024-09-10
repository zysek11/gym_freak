import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../Controllers/GroupsController.dart';
import '../../../database_classes/DatabaseHelper.dart';
import '../../../database_classes/Group.dart';

class PickGroupGroups extends StatefulWidget {
  const PickGroupGroups({super.key});

  @override
  State<PickGroupGroups> createState() => _PickGroupGroupsState();
}

class _PickGroupGroupsState extends State<PickGroupGroups> {
  int picked_group_id = -1;
  MultiSelectController msc = MultiSelectController();

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }


  Future<void> _loadGroups() async {
    await GroupsManager.gManager.initiateOrClearGroups(null,"A-Z");
  }


  void _onCheckboxChanged(int id) {
    setState(() {
      picked_group_id = id;
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
                alignment: Alignment.topCenter,
                child: Text(
                  "Select groups",
                  style: TextStyle(color: Colors.black, fontSize: 26),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Groups>>(
                future: GroupsManager.gManager.groups,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No exercises found.'));
                  } else {
                    List<Groups> groups = snapshot.data!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 6 / 5,
                      ),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        Groups group = groups[index];
                        int series = group.exercises.length * 3;
                        int estimatedLeft = series * 3;
                        int estimatedRight = series * 4;
                        bool isSelected = picked_group_id == group.id? true : false;
                        return GestureDetector(
                          onTap: () {
                            _onCheckboxChanged(group.id!);
                          },
                          child: Card(
                            color: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        group.iconPath,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                      ),
                                      Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected
                                                ? Color(0xFF2A8CBB)
                                                : Colors.black,
                                            width: 1,
                                          ),
                                          color: isSelected
                                              ? Color(0xFF2A8CBB)
                                              : Colors.transparent,
                                        ),
                                        width: 32,
                                        height: 32,
                                        child: isSelected
                                            ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 24,
                                        )
                                            : null,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    group.name,
                                    style: TextStyle(
                                      fontSize: 21,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/weights.png",
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10,),
                                      Text(group.exercises.length < 2 ? "${group.exercises.length} exercise":
                                      "${group.exercises.length} exercises",
                                        style: TextStyle(fontSize: 18),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18,right: 18,top: 6,bottom: 12),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF2A8CBB),
                  backgroundColor: Color(0xFF2A8CBB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context, picked_group_id);
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
