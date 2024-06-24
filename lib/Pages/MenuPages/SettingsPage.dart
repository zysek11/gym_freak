import 'package:flutter/material.dart';
import 'package:gym_freak/Language/LanguageJson.dart';
import 'package:provider/provider.dart';

import '../../Language/LanguageProvider.dart';
import '../../Theme/DarkThemeProvider.dart';
import '../../Theme/Styles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late String selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    Styles styles = Styles();
    styles.setColors(themeChange.darkTheme);
    final langChange = Provider.of<LanguageProvider>(context);
    selectedLanguage = langChange.language;
    print("jezyk: "+ selectedLanguage);
    Map<String, String> ls = langChange.localizedStrings;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 20,bottom: 10),
          child: SingleChildScrollView(
            child:
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(ls['settings']!.toUpperCase(), style: TextStyle( // Ustawienie stylu tekstu
                        fontFamily: 'Jaapokki',
                        fontSize: 35,
                        color: Color(0xFF2A8CBB)
                    ),),
                  ),
                  SizedBox(height: 40),
                  Container(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            ls['settings_language']!,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedLanguage,
                            items: List.generate(LanguageJson.languages.length, (index) {
                              return DropdownMenuItem<String>(
                                value: LanguageJson.languages[index],
                                child: Text(LanguageJson.languages[index]),
                              );
                            }),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                  langChange.language = newValue;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ),
        )
      ),
    );
  }
}
