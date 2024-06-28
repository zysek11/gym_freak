import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../Language/LanguageProvider.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';
import 'Exercises/ExercisesPage.dart';
import 'Settings/SettingsPage.dart';
import 'Workout/WorkoutPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> _screens = [
    const WorkoutPage(),
    const ExercisesPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Map<String, String> ls = langChange.localizedStrings;
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 85,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            color: Colors.white,
            activeColor: Color(0xFF2A8CBB),
            duration: Duration(milliseconds: 300),
            gap: 8,
            padding: EdgeInsets.all(12),
            onTabChange: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            tabs: [
              GButton(
                icon: Ionicons.home_outline,
                iconSize: 0,
                text: ls['workout']!,
                textStyle: TextStyle( // Ustawienie stylu tekstu
                  fontFamily: 'Jaapokki',
                  fontSize: 21,
                  color: Color(0xFF2A8CBB)
                ),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/menu/workout.png',
                      height: 64,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                border: currentIndex == 0
                    ? Border.all(color: Colors.blue)
                    : Border(),
              ),
              GButton(
                icon: Ionicons.home_outline,
                iconSize: 0,
                text: ls['exercises']!,
                textStyle: TextStyle( // Ustawienie stylu tekstu
                    fontFamily: 'Jaapokki',
                    fontSize: 21,
                    color: Color(0xFF2A8CBB)
                ),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/menu/exercises.png',
                      height: 64,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                border: currentIndex == 1
                    ? Border.all(color: Colors.blue)
                    : Border(),
              ),
              GButton(
                icon: Ionicons.home_outline,
                iconSize: 0,
                text: ls['settings']!,
                textStyle: TextStyle( // Ustawienie stylu tekstu
                    fontFamily: 'Jaapokki',
                    fontSize: 23,
                    color: Color(0xFF2A8CBB)
                ),
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/menu/settings.png',
                      height: 62,
                    ),
                    SizedBox(width: 8),
                  ],
                ),
                border: currentIndex == 2
                    ? Border.all(color: Color(0xFF2A8CBB))
                    : Border(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
