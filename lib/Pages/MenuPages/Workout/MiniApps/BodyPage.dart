import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/Workout/MiniApps/MeaserementMapPage.dart';
import 'package:gym_freak/database_classes/DatabaseHelper.dart';
import 'package:gym_freak/database_classes/Profile.dart';
import 'package:gym_freak/database_classes/Measurement.dart';
import 'package:intl/intl.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {

  @override
  void initState() {
    super.initState();
  }


  Future<List<Measurement>> _loadMeasurements() async {
    return await DatabaseHelper().getLatestMeasurementsByProfile(1);
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadMeasurements();
    });
  }

  Future<bool> _addMeasurement(String name, double value, String unit, DateTime selectedDate) async {
    bool validation = await DatabaseHelper().checkMeasurementByName(name);
    if(validation == false){
      return false;
    }
    final newMeasurement = Measurement(
      name: name.toUpperCase(),
      value: value,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
      active: 1,
      profile_id: 1,
      unit: unit,
    );
    await DatabaseHelper().insertMeasurement(newMeasurement);
    _refreshData(); // Odświeżenie listy po dodaniu
    return true;
  }


  Future<void> _showAddMeasurementDialog() async {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    final unitController = TextEditingController();
    String errorMessage = "";
    DateTime selectedDate = DateTime.now();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  "New measurement",
                  style: TextStyle(
                    color: Color(0xFF2A8CBB),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
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
                    mainAxisSize: MainAxisSize.max,
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
                  // Wybór daty
                  Row(
                    children: [
                      const Text(
                        "Date: ",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      TextButton(
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(DateTime.now().year - 5),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color(0xFF2A8CBB), // Kolor nagłówka i podświetlenia dni
                                      onPrimary: Colors.white, // Kolor tekstu w nagłówku
                                      onSurface: Colors.black, // Kolor tekstu w dniach
                                    ),
                                    dialogBackgroundColor: Colors.white, // Tło DatePicker
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
                            Icon(Icons.calendar_month, color: Color(0xFF2A8CBB),
                            size: 22,)
                          ],
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
              actions: [
                Row(
                  mainAxisSize: MainAxisSize.max,
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

                        if (name.isNotEmpty && value > 0 && unit.isNotEmpty) {
                          bool notExists = await _addMeasurement(name, value, unit, selectedDate);
                          if (notExists) {
                            Navigator.of(context).pop();
                          } else {
                            setState(() {
                              errorMessage = "Measurement with this name already exists.";
                            });
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
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
                  image: AssetImage("assets/ui/measurements_bg.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "MEASUREMENTS",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'JaapokkiSubtract',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10),
                  Image.asset("assets/icons/bicep.png", width: 100, height: 100),
                  SizedBox(height: 20),
                  Text(
                    "Best place after whole month of \nhard ass workouts.",
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
              child: FutureBuilder<List<Measurement>>(
                future: _loadMeasurements(), // Wczytywanie danych
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No measurements available.'));
                  } else {
                    // Dane są załadowane, używamy listy measurements z FutureBuildera
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                        child: _buildMeasurementSection(
                          title: "MEASUREMENTS",
                          measurements: snapshot.data!, // Przekazujemy dane z FutureBuildera
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Helper method to build a measurement section
  Widget _buildMeasurementSection({required String title, required List<Measurement> measurements}) {
    return Stack(
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
              children: measurements.isNotEmpty
                  ? measurements
                  .map((measurement) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MeasurementMapPage(
                        measurementName: measurement.name,
                      ),
                    ),
                  ).then((value) {
                    if (value == true) {
                      // Wartość true wskazuje, że potrzebujesz odświeżenia danych po powrocie
                      _refreshData(); // Wywołanie funkcji odświeżającej dane
                    }
                  });
                },
                child: Column(
                  children: [
                    _buildMeasurementRow(
                      measurement.name.toUpperCase(),
                      "${measurement.value} ${measurement.unit}",
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ))
                  .toList()
                  : [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child:
                  Center(child: Text(
                    "No measurements available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),)
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
    );
  }

  // Helper method to create a row with measurement label and value
  Widget _buildMeasurementRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontFamily: "Jaapokki",
          ),
        ),
        Row(
          children: [
            Text(
              value,
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
    );
  }
}
