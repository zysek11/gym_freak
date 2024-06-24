import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Language/LanguageProvider.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    Map<String, String> ls = langChange.localizedStrings;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("ep"),
        ),
      ),
    );;
  }
}
