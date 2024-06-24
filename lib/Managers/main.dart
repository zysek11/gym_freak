import 'package:flutter/material.dart';
import 'package:gym_freak/Pages/MenuPages/WorkoutPage.dart';
import 'package:gym_freak/Pages/StarterPages/Starter1.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;

import '../Language/LanguageProvider.dart';
import '../Pages/MenuPages/MainPage.dart';
import '../Theme/DarkThemeProvider.dart';
import '../Theme/Styles.dart';
import '../database_classes/DatabaseHelper.dart';
import 'Initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().database;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  LanguageProvider languageProvider = LanguageProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await themeChangeProvider.darkThemePreference.getTheme();
  }

  Future<void> getCurrentAppLanguage() async {
    await languageProvider.loadInitialLanguage();
  }

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    getCurrentAppLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeChangeProvider),
        ChangeNotifierProvider(create: (_) => languageProvider),
      ],
      child: Consumer2<DarkThemeProvider, LanguageProvider>(
        builder: (context, themeValue, langValue, child) {
          Styles styles = Styles();
          styles.setColors(themeValue.darkTheme);
          // Uzyskiwanie danych z JSON
          Map<String, String> localizedStrings = langValue.localizedStrings;

          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Initializer(),
          );
        },
      ),
    );
  }
}
