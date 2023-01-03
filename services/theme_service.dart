import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  ThemeService(this.sharedPreferences);

  static const darkThemeKey = "dark_theme";
  static const hideGradesKey = "hide_grades";

  bool _darkTheme = false;
  bool _hideGrades = false;

  set darkTheme(bool value) {
    _darkTheme = value;
    sharedPreferences.setBool(darkThemeKey, value);
    notifyListeners();
  }

  set hideGrades(bool value) {
    _hideGrades = value;
    sharedPreferences.setBool(hideGradesKey, value);
    notifyListeners();
  }

  bool get darkTheme {
    return sharedPreferences.getBool(darkThemeKey) ?? _darkTheme;
  }

  bool get hideGrades {
    return sharedPreferences.getBool(hideGradesKey) ?? _hideGrades;
  }
}
