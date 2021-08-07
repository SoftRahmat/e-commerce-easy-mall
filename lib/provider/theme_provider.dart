import 'package:easy_mall_shop/models/dark_theme_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreferences darkThemePreferences = DarkThemePreferences();
  bool _darkTheme = false;
  bool get darkTheme=> _darkTheme;

  set darkTheme(bool value){
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}