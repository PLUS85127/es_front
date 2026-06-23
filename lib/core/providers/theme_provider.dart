import 'package:flutter/material.dart';

//este sirve para cambiar entre tema claro y oscuro
class ThemeProvider extends ChangeNotifier {
  //le decimos que por defecto use el tema claro
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}
