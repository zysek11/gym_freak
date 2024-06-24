import 'package:flutter/material.dart';
import 'LanguageJson.dart';

class LanguageProvider with ChangeNotifier {
  LanguageJson languageJson = LanguageJson();
  String _language = "en";
  Map<String, String> _localizedStrings = {};

  String get language => _language;
  Map<String, String> get localizedStrings => _localizedStrings;

  set language(String value) {
    _language = value;
    languageJson.setSelectedLanguage(value);
    _loadLocalizedStrings();
  }

  Future<void> _loadLocalizedStrings() async {
    _localizedStrings = await LanguageJson.loadLanguage(_language);
    notifyListeners();
  }

  Future<void> loadInitialLanguage() async {
    _language = await languageJson.getSelectedLanguage();
    await _loadLocalizedStrings();
  }
}