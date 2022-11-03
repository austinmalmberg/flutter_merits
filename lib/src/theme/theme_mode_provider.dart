import 'package:flutter/material.dart';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;

  ThemeModeProvider([ThemeMode initial = ThemeMode.light]) : _mode = initial;

  void toggle() {
    _mode = mode != ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }
}
