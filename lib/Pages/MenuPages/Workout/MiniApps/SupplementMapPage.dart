
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gym_freak/database_classes/DatabaseHelper.dart';
import 'package:gym_freak/database_classes/Supplement.dart';
import 'package:gym_freak/uiElements/CircularCurvedSegments.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../Controllers/SupplementController.dart';
import '../During/WorkoutWidgets.dart';

class SupplementMapPage extends StatefulWidget {
  final int id;
  const SupplementMapPage({super.key, required this.id});

  @override
  State<SupplementMapPage> createState() => _SupplementMapPageState();
}

class _SupplementMapPageState extends State<SupplementMapPage> {
  TextEditingController instructionsTec = TextEditingController();

  Future<void> _loadSupplements() async {
    await SupplementManager.sManager.getSupplements();
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context, Supplement? supplement) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              "Deletion",
              style: TextStyle(
                color: Color(0xFF2A8CBB),
                fontSize: 27,
              ),
            ),
          ),
          content: Text(
            "Are you sure you want to delete this supplement?",
            style: TextStyle(fontSize: 20),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF2A8CBB),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF2A8CBB),
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () async {
                    await SupplementManager.sManager.removeSupplement(supplement!.id!);
                    Navigator.of(context).pop(true); // Return true on delete
                  },
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed without selection
  }


  Widget getCcsElements(Supplement supplement){
    if(supplement.checkCounterFlag != 0 && supplement.definiteFlag == 1 && supplement.status == 1){
      String text = supplement.checkCounterFlag == 1 ? " TODAY" : " THIS WEEK";
      final DateTime today = DateTime.now();
      DateTime startDate = DateFormat("yyyy-MM-dd").parse(supplement.dateOfStart);
      DateTime endDate = DateFormat("yyyy-MM-dd").parse(supplement.dateOfEnd!);
      int counter = today.difference(startDate).inDays;
      int alldays = endDate.difference(startDate).inDays;
      int percentagePassed = ((counter.toDouble() / alldays.toDouble()) * 100).toInt();
      return Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: getCcsColumn(true, supplement.counter!, supplement.suppLimit!,
                    "${supplement.counter!} OF ${supplement.suppLimit!}", text, supplement: supplement)
            ),
            Expanded(
              flex: 1,
              child: getCcsColumn(false, counter, alldays,
                  "$percentagePassed %", " COMPLETED")
            )
          ],
        ),
      );
    }
    else if(supplement.checkCounterFlag == 0 && supplement.definiteFlag == 1){
      final DateTime today = DateTime.now();
      DateTime startDate = DateFormat("yyyy-MM-dd").parse(supplement.dateOfStart);
      DateTime endDate = DateFormat("yyyy-MM-dd").parse(supplement.dateOfEnd!);
      int counter = today.difference(startDate).inDays;
      int alldays = endDate.difference(startDate).inDays;
      int percentagePassed = ((counter.toDouble() / alldays.toDouble()) * 100).toInt();
      return Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
          child: getCcsColumn(false, counter, alldays,
              "$percentagePassed %", " DONE"),
        ),
      );
    }
    else if(supplement.checkCounterFlag != 0 && supplement.definiteFlag == 0   && supplement.status == 1){
      String text = supplement.checkCounterFlag == 1 ? " TODAY" : " THIS WEEK";
      return Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
          child: getCcsColumn(true, supplement.counter!, supplement.suppLimit!,
              "${supplement.counter!} OF ${supplement.suppLimit!}", text, supplement: supplement),
        ),
      );
    }
    return Container();
  }

  Column getCcsColumn(bool editable, int circular_start, int circular_limit, String conn1, String conn2, {Supplement? supplement}){
    return Column(
      children: [
        CircularCurvedSegments(numberOfVertices: circular_limit, numberOfConnectors: circular_start),
        SizedBox(height: 15,),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: conn1,
                style: TextStyle(
                  fontFamily: 'Jaapokki',
                  fontSize: 24,
                  color: Color(0xff2A8CBB),
                ),
              ),
              TextSpan(
                text: conn2,
                style: const TextStyle(fontSize: 20, fontFamily: 'Jaapokki'),
              ),
            ],
          ),
        ),
        SizedBox(height: 15,),
        if(editable)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if(supplement!.counter! > 0) {
                    supplement.counter = supplement.counter! - 1;
                    await SupplementManager.sManager.updateSupplement(supplement);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A8CBB), // Blue background
                  shape: CircleBorder(), // Circular shape
                  padding: EdgeInsets.all(10), // Adjust padding for button size
                  minimumSize: Size(80, 40), // Set minimum size
                ),
                child: Text(
                  "-",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if(supplement!.counter! < supplement.suppLimit!) {
                    supplement.counter = supplement.counter! + 1;
                    await SupplementManager.sManager.updateSupplement(supplement);
                    setState(() {
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A8CBB), // Blue background
                  shape: CircleBorder(), // Circular shape
                  padding: EdgeInsets.all(10), // Adjust padding for button size
                  minimumSize: Size(80, 40), // Set minimum size
                ),
                child: Text(
                  "+",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _showEditMeasurementDialog(Supplement supplement) async {
    final nameController = TextEditingController(text: supplement.name);
    final valueController = TextEditingController(text: supplement.value.toString());
    final unitController = TextEditingController(text: supplement.unit);
    final descController = TextEditingController(text: supplement.description);
    String errorMessage = "";
    DateFormat format = DateFormat("yyyy-MM-dd");
    DateTime endDate = supplement.dateOfEnd != null? format.parse(supplement.dateOfEnd!)
      : DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day);
    bool _isChecked = supplement.definiteFlag == 0? true: false;
    int countType = supplement.checkCounterFlag;
    List<String> types = ["No counting", "Count few times a day", "Count few times a week"];
    int daysInAWeek = countType != 0 ? supplement.suppLimit! : 1;

    // counter for max days
    final DateTime today = DateTime.now();
    DateTime startDate = DateFormat("yyyy-MM-dd").parse(supplement.dateOfStart);


    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  "New supplement",
                  style: TextStyle(
                    color: Color(0xFF2A8CBB),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: Color(0xff444444)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2A8CBB)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff444444)),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      cursorColor: Color(0xff444444),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: valueController,
                            decoration: InputDecoration(
                              labelText: "Value",
                              labelStyle: TextStyle(color: Color(0xff444444)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF2A8CBB)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff444444)),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            cursorColor: Color(0xff444444),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: unitController,
                            decoration: InputDecoration(
                              labelText: "Unit",
                              labelStyle: TextStyle(color: Color(0xff444444)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF2A8CBB)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff444444)),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff444444),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (!_isChecked) ...[
                      SizedBox(height: 10),
                      Row(
                        children: [
                          const Text(
                            "End date: ",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: endDate,
                                firstDate: DateTime(DateTime.now().year,DateTime.now().month, DateTime.now().day),
                                lastDate: endDate.add(Duration(days: 365 - today.difference(startDate).inDays)),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Color(0xFF2A8CBB),
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  endDate = pickedDate;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd').format(endDate) + " | ",
                                  style: const TextStyle(fontSize: 18, color: Color(0xFF2A8CBB)),
                                ),
                                Icon(
                                  Icons.calendar_month,
                                  color: Color(0xFF2A8CBB),
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 10),
                    CheckboxListTile(
                      title: Text(
                        "Set to indefinite period",
                        style: TextStyle(color: Colors.black),
                      ),
                      value: _isChecked,
                      activeColor: Color(0xFF2A8CBB),
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    SizedBox(height: 10),
                    DropdownButton<int>(
                      value: countType,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      underline: SizedBox.shrink(), // Usuwa domyślną linię pod spodem
                      dropdownColor: Colors.white, // Kolor menu rozwijanego
                      items: types.asMap().entries.map<DropdownMenuItem<int>>((entry) {
                        int index = entry.key;
                        String value = entry.value;
                        return DropdownMenuItem<int>(
                          value: index, // Ustawienie indeksu jako value
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          countType = newValue!; // Przypisz wybrany indeks
                        });
                      },
                    ),
                    if(countType != 0)
                      ...[
                        SizedBox(height: 15,),
                        RatingBar(
                            allowHalfRating: false,
                            initialRating: daysInAWeek.toDouble(),
                            minRating: 1,
                            itemCount: 7,
                            direction: Axis.horizontal,
                            itemSize: 32,
                            itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
                            ratingWidget: RatingWidget(
                              full: Image.asset("assets/icons/calendar_full.png",),
                              empty: Image.asset("assets/icons/calendar_empty.png",),
                              half: Container(),
                            ),
                            onRatingUpdate: (days){
                              daysInAWeek = days.toInt();
                            }),
                        SizedBox(height: 10,),
                      ],
                    SizedBox(height: 20),
                    TextFormField(
                      controller: descController,
                      minLines: 3,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'No, I\'m not busting my ass...',
                        hintStyle: TextStyle(
                          fontSize: 19,
                          color: Color(0xff444444),
                          fontFamily: 'Jaapokki',
                        ),
                        filled: true,
                        fillColor: Colors.white, // Background color
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color:Colors.black, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color:Color(0xFF2A8CBB), width: 1.0),
                        ),
                      ),
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFF2A8CBB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF2A8CBB),
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final value = double.tryParse(valueController.text) ?? 0.0;
                        final unit = unitController.text;
                        final name = nameController.text;
                        DateFormat format = DateFormat("dd-MM-yyyy");
                        DateTime startDate = format.parse(supplement.dateOfStart);
                        bool validation = await DatabaseHelper().checkSupplementByName(name.toUpperCase(), id: supplement.id!);


                        if (name.isEmpty || value <= 0 || unit.isEmpty) {
                          setState((){
                            errorMessage = "Fill the fields first.";
                          });
                        }
                        else if(!endDate.isAfter(startDate) && !_isChecked){
                          setState((){
                            errorMessage = "End date has to be after start date.";
                          });
                        }
                        else if(validation == false){
                          setState((){
                            errorMessage = "Suplement o takiej nazwie już istnieje";
                          });
                        }
                        else{
                          supplement.name = name;
                          supplement.value = value;
                          supplement.unit = unit;
                          supplement.definiteFlag = !_isChecked ? 1 : 0;
                          supplement.dateOfEnd = !_isChecked ? DateFormat('yyyy-MM-dd').format(endDate): null;
                          if(supplement.checkCounterFlag != 0 && supplement.counter! > daysInAWeek){
                              supplement.counter = countType != 0 ? daysInAWeek : null;
                          }
                          else if(supplement.checkCounterFlag == 0){
                            supplement.counter = countType != 0 ? 0 : null;
                          }
                          supplement.checkCounterFlag = countType;
                          supplement.suppLimit = countType != 0 ? daysInAWeek : null;
                          supplement.description = descController.text;
                          await SupplementManager.sManager.updateSupplement(supplement);
                          if(context.mounted){
                            await SupplementManager.sManager.getSupplements();
                            Navigator.of(context).pop(true);
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    _loadSupplements();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8CBB),
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Supplement',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontFamily: 'Jaapokki',
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () async {
            Navigator.pop(context, true);
          },
        ),
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Consumer<SupplementManager>(builder: (context, manager, child) {
            if (manager.supplements.isEmpty) {
              return const Center(child: Text('No supplements available.'));
            }
            final supplement = manager.supplements.firstWhere(
                  (supp) => supp.id == widget.id
            );

            final DateTime today = DateTime.now();
            DateTime startDate = DateFormat("yyyy-MM-dd").parse(supplement.dateOfStart);
            int counter = today.difference(startDate).inDays;
            instructionsTec.text = supplement.description != null? supplement.description! : "";
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            supplement.name,
                            style: const TextStyle(fontSize: 35, fontFamily: 'Jaapokki'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "status:   ",
                                style: const TextStyle(fontSize: 30,
                                    color: Colors.black,
                                    fontFamily: 'Jaapokki'),
                              ),
                              if(supplement.status == 1)
                                ...[
                                  Text(
                                    "active",
                                    style: const TextStyle(fontSize: 30,
                                        color: Colors.black,
                                        fontFamily: 'Jaapokki'),
                                  ),
                                  SizedBox(width: 10,),
                                  Image.asset("assets/icons/green_flag.png")
                                ]
                              else if(supplement.status == 0)
                                ...[
                                  Text(
                                    "done",
                                    style: const TextStyle(fontSize: 30,
                                        color: Colors.black,
                                        fontFamily: 'Jaapokki'),
                                  ),
                                  SizedBox(width: 10,),
                                  Image.asset("assets/icons/red_flag.png")
                                ]
                            ]
                        ),
                        getCcsElements(supplement),
                        const SizedBox(height: 40),
                        Text(
                          'Value:   ${supplement.value} ${supplement.unit}',
                          style: const TextStyle(fontSize: 23,
                              fontFamily: 'Jaapokki',
                              color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Start Date:   ${supplement.dateOfStart}',
                          style: const TextStyle(fontSize: 23,
                              fontFamily: 'Jaapokki',
                              color: Colors.black),
                        ),
                        if(supplement.dateOfEnd != null)
                          ...[
                            const SizedBox(height: 25),
                            Text(
                              'End Date:   ${supplement.dateOfEnd}',
                              style: const TextStyle(fontSize: 23,
                                  fontFamily: 'Jaapokki',
                                  color: Colors.black),
                            ),
                          ],
                        const SizedBox(height: 25),
                        Text(
                          'Number of the day:   ${counter+1}',
                          style: const TextStyle(fontSize: 23,
                              fontFamily: 'Jaapokki',
                              color: Colors.black),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: instructionsTec,
                          readOnly: true,
                          minLines: 5,
                          maxLines: 10,
                          style: TextStyle(
                            fontSize: 19, // Rozmiar czcionki dla wpisywanego tekstu
                            color: Colors.black, // Kolor tekstu
                            fontFamily: 'Jaapokki', // Czcionka, jeśli chcesz zachować spójność
                          ),
                          decoration: InputDecoration(
                            hintText: 'No, I\'m not busting my ass...',
                            hintStyle: TextStyle(
                              fontSize: 19,
                              color: Color(0xff444444),
                              fontFamily: 'Jaapokki',
                            ),
                            filled: true,
                            fillColor: Color(0xFFF9F9F9), // Background color
                            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: Consumer<SupplementManager>(
        builder: (context, manager, child) {
          if (manager.supplements.isNotEmpty) {
            if (manager.supplements.isEmpty) {
              return const Center(child: Text('No supplements available.'));
            }
            final supplement = manager.supplements.firstWhere(
                    (supp) => supp.id == widget.id
            );
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'editButton', // Unikalny heroTag
                  onPressed: () {
                    _showEditMeasurementDialog(supplement);
                    },
                  backgroundColor: const Color(0xFF2A8CBB),
                  child: const Icon(Icons.edit, color: Colors.white),
                ),
                const SizedBox(height: 20), // Odstęp między przyciskami
                FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.close, color: Colors.white),
                  onPressed: () async {
                    bool decision = await _showDeleteConfirmationDialog(
                        context, supplement);
                    if (decision) {
                      Navigator.of(context).pop();
                    }
                  }
                ),
              ],
            );
          }
          return const SizedBox.shrink(); // Placeholder, gdy przyciski powinny być ukryte
        },
      ),
    );
  }
}
