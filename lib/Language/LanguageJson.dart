import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageJson {
  static const String _defaultLanguageCode = "polski";
  static const String _languageKey = 'selectedLanguage';

  static const List<String> languages = ["english", "polski"];
  static const List<String> languages_short = ["en", "pl"];

  static String convertFromLanguageCode(String language){
    int index = languages.indexOf(language);
    return languages_short[index];
  }

  static String convertFromShortCode(String languageS){
    int index = languages_short.indexOf(languageS);
    return languages[index];
  }

  static Future<Map<String, String>> loadLanguage(String language) async {
    String languageCode = convertFromLanguageCode(language);
    String jsonString = await rootBundle.loadString('assets/jsons/$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  setSelectedLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  Future<String> getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? _defaultLanguageCode;
  }
}