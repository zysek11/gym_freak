import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  late Future<List<Supplement>> supplementList;

  @override
  void initState() {
    supplementList = _loadSupplements();
    super.initState();
  }


  Future<bool> _addSupplement(String name, double value, String unit, DateTime selectedDate,
      DateTime endDate, bool indefinite, bool counting, int times) async {
    bool validation = await DatabaseHelper().checkSupplementByName(name.toUpperCase());
    print('validation: ' + validation.toString());
    if(validation == false){
      return false;
    }
    final newSupplement = Supplement(
      name: name.toUpperCase(),
      value: value,
      indefiniteFlag: indefinite ? 1 : 0,
      dateOfStart: DateFormat('yyyy-MM-dd').format(selectedDate),
      dateOfEnd: indefinite ? DateFormat('yyyy-MM-dd').format(endDate): null,
      todayFlag: 0,
      checkCounterFlag: counting ? 1 : 0,
      counter: counting ? 0 : null,
      suppLimit: counting ? times : null,
      profileId: 1,
      unit: unit,
    );
    await DatabaseHelper().insertSupplement(newSupplement);
    await _refreshData(); // Refresh list after adding
    return true;
  }

  Future<void> updateSupplement(Supplement supplement) async {
    await DatabaseHelper().updateSupplement(supplement);
  }

  Future<List<Supplement>> _loadSupplements() async {
    return DatabaseHelper().getLatestSupplementsByProfile(1);
  }

  Future<void> _refreshData() async {
    final supplements = await _loadSupplements();
    setState(() {
      supplementList = Future.value(supplements);
    });
  }


  Future<void> _showAddMeasurementDialog() async {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    final unitController = TextEditingController();
    String errorMessage = "";
    DateTime selectedDate = DateTime.now();
    selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    DateTime endDate = selectedDate;
    bool _isChecked = false;
    bool _counting = false;
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
                              firstDate: selectedDate.subtract(Duration(days: 6)),
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

                            if (pickedDate != null && pickedDate != selectedDate) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                DateFormat('yyyy-MM-dd').format(selectedDate) + " | ",
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
                                initialDate: selectedDate.add(Duration(days: 1)),
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
                              if (pickedDate != null && pickedDate != selectedDate) {
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
                    CheckboxListTile(
                      title: Text(
                        "Count times in a week",
                        style: TextStyle(color: Colors.black),
                      ),
                      value: _counting,
                      activeColor: Color(0xFF2A8CBB),
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        setState(() {
                          _counting = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    if(_counting)
                      Row(
                        children: [
                          Text(
                            "Pick days in a week: ",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          SizedBox(width: 15),
                          DropdownButton<int>(
                            value: daysInAWeek,
                            onChanged: (int? newValue) {
                              setState(() {
                                daysInAWeek = newValue!;
                              });
                            },
                            items: List.generate(
                              7,
                                  (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text((index + 1).toString()),
                              ),
                            ),
                          ),
                        ],
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

                        if (name.isEmpty || value <= 0 || unit.isEmpty) {
                          setState((){
                            errorMessage = "Fill the fields first.";
                          });
                        }
                        else if(!endDate.isAfter(selectedDate) && !_isChecked){
                          setState((){
                            errorMessage = "End date has to be after start date.";
                          });
                        }
                        else{
                          bool notExists = await _addSupplement(name, value, unit, selectedDate, endDate, _isChecked, _counting, daysInAWeek);
                          if (notExists) {
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              errorMessage = "Supplement with this name already exists.";
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

  // Helper method to create a row with measurement label and value
  Widget _buildSupplementRow(Supplement supplement) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Dodanie minimalnej wysokości kolumny
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              supplement.name,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: "Jaapokki",
              ),
            ),
            Row(
              children: [
                Text(
                  supplement.value.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: "Jaapokki",
                  ),
                ),
                const SizedBox(width: 25),
                const Icon(Icons.arrow_forward, color: Colors.black, size: 28),
              ],
            ),
          ],
        ),
        if (supplement.checkCounterFlag == 1)
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircularCurvedSegments(numberOfVertices: supplement.suppLimit!, numberOfConnectors: supplement.counter!),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${supplement.counter!} OF ${supplement.suppLimit!}',
                              style: const TextStyle(
                                fontSize: 23,
                                color: Color(0xFF2A8CBB),
                                fontFamily: "Jaapokki",
                              ),
                            ),
                            TextSpan(
                              text: ' THIS WEEK',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: "Jaapokki",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Already taken",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "Jaapokki",
                        ),
                      ),
                      value: supplement.todayFlag == 1 ? true : false,
                      activeColor: Color(0xFF2A8CBB),
                      checkColor: Colors.white,
                      onChanged: (bool? value) async {
                          supplement.todayFlag = value! ? 1 : 0;
                          if(value){
                            supplement.counter = supplement.counter! + 1;

                          }else{
                            supplement.counter = supplement.counter! - 1;
                          }
                          await updateSupplement(supplement);
                        setState(() {
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ],
                ),
              ),
            ],
          ),
        if(supplement.checkCounterFlag == 0)
          CheckboxListTile(
            title: Text(
              "Already taken",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontFamily: "Jaapokki",
              ),
            ),
            value: supplement.todayFlag == 1 ? true : false,
            activeColor: Color(0xFF2A8CBB),
            checkColor: Colors.white,
            onChanged: (bool? value) {
              setState(() async {
                supplement.todayFlag = value! ? 1 : 0;
                await updateSupplement(supplement);
              });
            },
            controlAffinity: ListTileControlAffinity.trailing,
          ),
      ],
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
                          "ADD MEASUREMENT",
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
                child: FutureBuilder<List<Supplement>>(
                  future: supplementList, // Load data with Future
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No measurements available.'));
                    } else {
                      List<Supplement> supplements = snapshot.data!;
                      print("elementy supp: " + supplements.length.toString());
                      String title = "SUPPLEMENTS";
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFF2A8CBB), width: 3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5, top: 45.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: supplements.isNotEmpty
                                        ? List.generate(
                                      supplements.length * 2 - 1, // Długość z uwzględnieniem dividerów
                                          (index) {
                                        if (index.isEven) {
                                          // Budowanie elementu
                                          final supplement = supplements[index ~/ 2];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SupplementMapPage(),
                                                ),
                                              ).then((value) {
                                                if (value == true) {
                                                  _refreshData();
                                                }
                                              });
                                            },
                                            child: _buildSupplementRow(supplement)
                                          );
                                        } else {
                                          // Dodawanie Dividera pomiędzy elementami
                                          return
                                            Padding(
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              child: Divider(
                                                color: Colors.grey,
                                                thickness: 1,
                                              ),
                                            );
                                        }
                                      },
                                    )
                                        : [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20.0),
                                        child: Center(
                                          child: Text(
                                            "No supplements added",
                                            style: TextStyle(fontSize: 18, color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                              ),
                              Positioned(
                                top: -10,
                                left: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

}
