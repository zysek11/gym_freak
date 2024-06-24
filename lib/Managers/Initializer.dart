import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../Pages/StarterPages/Starter1.dart';
import '../Pages/MenuPages/MainPage.dart';
import '../Language/LanguageProvider.dart';
import '../Theme/DarkThemeProvider.dart';
import '../database_classes/DatabaseHelper.dart';

class Initializer extends StatefulWidget {
  const Initializer({super.key});

  @override
  _InitializerState createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _checkUserExistence();
  }

  Future<void> _checkUserExistence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userExist = prefs.getBool('userExist') ?? false;

    if (!userExist) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const StarterOne()),
        );
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}