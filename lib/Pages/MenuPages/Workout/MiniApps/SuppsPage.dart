import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../Controllers/SupplementController.dart';
import '../../../../database_classes/DatabaseHelper.dart';
import '../../../../database_classes/Supplement.dart';
import '../../../../uiElements/CircularCurvedSegments.dart';
import 'SupplementMapPage.dart';

class SuppsPage extends StatefulWidget {
  const SuppsPage({super.key});

  @override
  State<SuppsPage> createState() => _SuppsPageState();
}

class _SuppsPageState extends State<SuppsPage> {
  @override
  void initState() {
    _loadSupplements();
    super.initState();
  }

  Future<void> _loadSupplements() async {
    await SupplementManager.sManager.getSupplements();
  }

  Future<void> _showAddMeasurementDialog() async {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    final unitController = TextEditingController();
    final descController = TextEditingController();
    String errorMessage = "";
    DateTime selectedDate = DateTime.now();
    selectedDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endDate = selectedDate;
    bool _isChecked = false;
    int countType = 0;
    List<String> types = ["No counting", "Count few times a day", "Count few times a week"];
    int daysInAWeek = 1;

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
                                borderSide:
                                    BorderSide(color: Color(0xFF2A8CBB)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff444444)),
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
                                borderSide:
                                    BorderSide(color: Color(0xFF2A8CBB)),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff444444)),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            cursorColor: Color(0xff444444),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Start date: ",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate:
                                  selectedDate.subtract(Duration(days: 6)),
                              lastDate: selectedDate.add(Duration(days: 6)),
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

                            if (pickedDate != null &&
                                pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(selectedDate) +
                                    " | ",
                                style: const TextStyle(
                                    fontSize: 18, color: Color(0xFF2A8CBB)),
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
                                initialDate:
                                    selectedDate.add(Duration(days: 1)),
                                firstDate: selectedDate.add(Duration(days: 1)),
                                lastDate: endDate.add(Duration(days: 365)),
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
                              if (pickedDate != null &&
                                  pickedDate != selectedDate) {
                                setState(() {
                                  endDate = pickedDate;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  DateFormat('yyyy-MM-dd').format(endDate) +
                                      " | ",
                                  style: const TextStyle(
                                      fontSize: 18, color: Color(0xFF2A8CBB)),
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
                      isExpanded: false,
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
                    if (countType != 0)
                      ...[
                        SizedBox(height: 15,),
                        RatingBar(
                          allowHalfRating: false,
                            initialRating: 1,
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
                          fontSize: 17,
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final value =
                            double.tryParse(valueController.text) ?? 0.0;
                        final unit = unitController.text;
                        final name = nameController.text;

                        if (name.isEmpty || value <= 0 || unit.isEmpty) {
                          setState(() {
                            errorMessage = "Fill the fields first.";
                          });
                        } else if (!endDate.isAfter(selectedDate) &&
                            !_isChecked) {
                          setState(() {
                            errorMessage =
                                "End date has to be after start date.";
                          });
                        } else {

                          bool notExists = await SupplementManager.sManager
                              .addSupplement(name, value, unit, selectedDate,
                                  endDate, _isChecked, countType, daysInAWeek, 1,
                              descController.text.isEmpty? null : descController.text);
                          if (notExists) {
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              errorMessage =
                                  "Supplement with this name already exists.";
                            });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/ui/supplements_bg.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SUPPLEMENTS",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: 'JaapokkiSubtract',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 20),
                Image.asset("assets/icons/whey.png", width: 100, height: 100),
                SizedBox(height: 40),
                Text(
                  "Taking some protein?\nYou found a good place.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'Jaapokki',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF2A8CBB),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                side: BorderSide(color: Color(0xFF2A8CBB), width: 3),
              ),
              onPressed: () {
                _showAddMeasurementDialog();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "ADD SUPPLEMENT",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontFamily: 'Jaapokki',
                      ),
                    ),
                    Image.asset("assets/icons/ruler.png"),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child:
                Consumer<SupplementManager>(builder: (context, manager, child) {
              if (manager.supplements.isEmpty) {
                return const Center(child: Text('No supplements available.'));
              }
              String title = "SUPPLEMENTS";
              print("test: "+manager.supplements[0].name);
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 25.0),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF2A8CBB), width: 3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, bottom: 5, top: 45.0),
                          child: Column(
                            children: [
                              for (int i = 0;
                                  i < manager.supplements.length;
                                  i++) ...[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SupplementMapPage(id: manager.supplements[i].id!),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 7),
                                    child: SupplementRowWidget(
                                      supplement: manager.supplements[i],
                                      onUpdate: (updatedSupplement) {
                                        manager.updateSupplement(updatedSupplement);
                                      },
                                    ),
                                  )
                                ),

                                if (i < manager.supplements.length - 1)
                                    Divider(
                                        color:  Color(0xFF2A8CBB), thickness: 2),

                              ],
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -10,
                        left: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          color: Colors.white,
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontFamily: "Jaapokki",
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          )
        ],
      )),
    );
  }
}

class SupplementRowWidget extends StatefulWidget {
  final Supplement supplement;
  final Function(Supplement) onUpdate;

  const SupplementRowWidget({
    Key? key,
    required this.supplement,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _SupplementRowWidgetState createState() => _SupplementRowWidgetState();
}
class _SupplementRowWidgetState extends State<SupplementRowWidget> {
  late Supplement supplement;

  @override
  void initState() {
    super.initState();
    supplement = widget.supplement;
  }

  @override
  void didUpdateWidget(SupplementRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.supplement != widget.supplement) {
      setState(() {
        supplement = widget.supplement;
      });
    }
  }

  Future<bool> _toggleTodayFlag(bool? value) async {
    // Determine if the conditions allow the operation to proceed
    if (value == true && supplement.counter! >= supplement.suppLimit!) {
      return false; // Return false if trying to increment beyond the limit
    } else if (value == false && supplement.counter! <= 0) {
      return false; // Return false if trying to decrement below zero
    }

    // Update the state as the conditions are valid
    setState(() {
      supplement.todayFlag = value! ? 1 : 0;
      if (value == true) {
        supplement.counter = supplement.counter! + 1;
      } else {
        supplement.counter = supplement.counter! - 1;
      }
    });

    // Update the supplement in the manager and notify the parent widget
    await SupplementManager.sManager.updateSupplement(supplement);
    widget.onUpdate(supplement);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print(supplement.checkCounterFlag);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              supplement.name,
              style: const TextStyle(fontSize: 20, color: Color(0xFF2A8CBB), fontFamily: "Jaapokki"),
            ),
            Row(
              children: [
                Text(
                  '${supplement.value} ${supplement.unit}',
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontFamily: "Jaapokki"),
                ),
                const SizedBox(width: 25),
                const Icon(Icons.arrow_forward, color: Colors.black, size: 28),
              ],
            ),
          ],
        ),
        if (supplement.checkCounterFlag != 0 && supplement.status == 1)
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CircularCurvedSegments(
                  numberOfVertices: supplement.suppLimit!,
                  numberOfConnectors: supplement.counter!,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${supplement.counter!} OF ${supplement.suppLimit!}',
                              style: const TextStyle(fontSize: 23, color: Color(0xFF2A8CBB), fontFamily: "Jaapokki"),
                            ),
                            if(supplement.checkCounterFlag == 1)
                            const TextSpan(
                              text: ' TODAY',
                              style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "Jaapokki"),
                            ),
                            if(supplement.checkCounterFlag == 2)
                              const TextSpan(
                                text: ' THIS WEEK',
                                style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "Jaapokki"),
                              ),
                          ],
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text(
                        "Already taken",
                        style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: "Jaapokki"),
                      ),
                      value: supplement.todayFlag == 1,
                      activeColor: Color(0xFF2A8CBB),
                      checkColor: Colors.white,
                      onChanged: _toggleTodayFlag,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ],
                ),
              ),
            ],
          ),
        if(supplement.status == 0)
          ...[
            SizedBox(height: 15,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "done",
                  style: const TextStyle(fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'Jaapokki'),
                ),
                SizedBox(width: 15,),
                Image.asset("assets/icons/red_flag.png", width: 28, height: 28,),
                SizedBox(width: 25,),
              ],
            )
          ]
      ],
    );
  }
}
