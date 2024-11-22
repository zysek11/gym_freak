import 'package:flutter/material.dart';
import 'package:gym_freak/database_classes/DatabaseHelper.dart';
import '../../../../database_classes/Measurement.dart';
import 'package:intl/intl.dart';

class MeasurementMapPage extends StatefulWidget {
  final String measurementName;
  const MeasurementMapPage({super.key, required this.measurementName});

  @override
  State<MeasurementMapPage> createState() => _MeasurementMapPageState();
}

class _MeasurementMapPageState extends State<MeasurementMapPage> {
  late Future<List<Measurement>> measurementHistory;

  @override
  void initState() {
    super.initState();
    measurementHistory = DatabaseHelper().getMeasurementsByNameSortedByDate(widget.measurementName);
  }

  void _refreshMeasurementHistory() {
    setState(() {
      measurementHistory = DatabaseHelper().getMeasurementsByNameSortedByDate(widget.measurementName);
    });
  }

  Future<void> _deleteMeasurement(int id) async {
    await DatabaseHelper().deleteMeasurement(id);
    _refreshMeasurementHistory(); // Odświeżenie listy po usunięciu
  }

  Future<void> _deleteMeasurementsByName(String name) async {
    await DatabaseHelper().deleteMeasurementsByName(name);
    _refreshMeasurementHistory();
  }

  Future<void> _addMeasurement(String name, double value, String unit,  DateTime selectedDate) async {
    final newMeasurement = Measurement(
      name: name.toUpperCase(),
      value: value,
      date: DateFormat('yyyy-MM-dd').format(selectedDate),
      active: 1,
      profile_id: 1, unit: unit, // Dopasuj do swojego kontekstu
    );
    await DatabaseHelper().insertMeasurement(newMeasurement);
    _refreshMeasurementHistory(); // Odświeżenie listy po dodaniu
  }

  Future<void> _showDeletionDialog(String name) async {

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Delete measurement",
              style: TextStyle(
                color: Color(0xFF2A8CBB),
                fontWeight: FontWeight.bold,
                fontSize: 24, // Ustawienie koloru na niebieski
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Text(
                "Are you sure u want to erase all measurement data?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18, // Ustawienie koloru na niebieski
                ),
              ),
              SizedBox(height: 15,),
            ],
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("No",
                    style: TextStyle(
                        color: Color(0xFF2A8CBB),
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF2A8CBB), // Kolor tła przycisku
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Padding wewnątrz przycisku
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Zaokrąglone rogi
                    ),
                  ),
                  onPressed: () {
                    _deleteMeasurementsByName(name);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF), // Kolor tekstu
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
                ),
              ],
            ),

          ],
        );
      },
    );
  }

  Future<void> _showAddMeasurementDialog(String name) async {
    final valueController = TextEditingController();
    final unitController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "New measurement",
              style: TextStyle(
                color: Color(0xFF2A8CBB),
                fontWeight: FontWeight.bold,
                fontSize: 24, // Ustawienie koloru na niebieski
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: valueController,
                      decoration: InputDecoration(
                        labelText: "Value",
                        labelStyle: TextStyle(color: Color(0xff444444)), // Kolor etykiety (Label)
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2A8CBB)), // Niebieska linia na dole po kliknięciu
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff444444)), // Szara linia na dole, gdy nieaktywne
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
                        labelStyle: TextStyle(color: Color(0xff444444)), // Kolor etykiety (Label)
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2A8CBB)), // Niebieska linia na dole po kliknięciu
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff444444)), // Szara linia na dole, gdy nieaktywne
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      cursorColor: Color(0xff444444),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
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
              SizedBox(height: 30,),
            ],
          ),
          actions: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel",
                    style: TextStyle(
                        color: Color(0xFF2A8CBB),
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF2A8CBB), // Kolor tła przycisku
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // Padding wewnątrz przycisku
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Zaokrąglone rogi
                    ),
                  ),
                  onPressed: () {
                    final value = double.tryParse(valueController.text) ?? 0.0;
                    final unit = unitController.text;
                    if (name.isNotEmpty && value > 0 && unit.isNotEmpty) {
                      _addMeasurement(name, value,unit, selectedDate);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Save",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF), // Kolor tekstu
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
                ),
              ],
            ),

          ],
        );
      },
    );
  }

  Widget _buildMeasurementListItem({
    required String date,
    required String label,
    required String value,
    required String unit,
    required VoidCallback onDelete,
  }) {
    String formattedDate = DateFormat('yyyy.MM.dd').format(DateTime.parse(date));

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30, left: 16.0,right: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                flex: 1,
                child: Divider(
                  color: Colors.blue,
                  thickness: 3.0,
                  endIndent: 8.0,
                ),
              ),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              const Expanded(
                flex: 3,
                child: Divider(
                  color: Color(0xFF2A8CBB),
                  thickness: 3.0,
                  indent: 10.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Jaapokki',
                  fontSize: 22.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 25.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  '$value $unit',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A8CBB),
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'History',
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
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        toolbarHeight: 70,
      ),
      body: FutureBuilder<List<Measurement>>(
        future: measurementHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No measurements found.'));
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 15.0,bottom: 15),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final measurement = snapshot.data![index];
                  return _buildMeasurementListItem(
                    date: measurement.date,
                    label: measurement.name,
                    value: measurement.value.toString(),
                    unit: measurement.unit,
                    onDelete: () => _deleteMeasurement(measurement.id!),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FutureBuilder<List<Measurement>>(
        future: measurementHistory,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Show FloatingActionButton only if data is loaded
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () => _showAddMeasurementDialog(widget.measurementName),
                  backgroundColor: const Color(0xFF2A8CBB),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                SizedBox(height: 20,),
                FloatingActionButton(
                  heroTag: 'deleteButton', // Unikalny heroTag
                  onPressed: () => _showDeletionDialog(widget.measurementName),
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            );
          }
          return const SizedBox.shrink(); // Placeholder when button should be hidden
        },
      ),
    );
  }
}
