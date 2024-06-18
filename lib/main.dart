import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/WorkoutPage.dart';
import 'package:gym_freak/Pages/StarterPages/Starter1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

import 'Pages/MenuPages/MainPage.dart';
import 'database_classes/DatabaseHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Initializer(),
    );
  }
}

class Initializer extends StatefulWidget {
  const Initializer({super.key});

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  void initState() {
    super.initState();
    _checkUserExistence();
  }

  Future<void> _checkUserExistence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userExist = prefs.getBool('userExist') ?? false;

    if (!userExist) {
      if(mounted) {
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StarterOne()),
      );
      }
    } else {
      await _loadDataFromDatabase();
      if(mounted) {
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
      }
    }
  }

  Future<void> _loadDataFromDatabase() async {

  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
