import 'package:flutter/material.dart';

class AppTheme {
  static const Color navyBlue = Color(0xFF000080);
  static const Color yellowDecorative = Color(0xFFFFD700);

  static const Color darkBackground = Color(0xFF050A24);
  static const Color darkCard = Color(0xFF10163A);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey.shade50,
    primaryColor: navyBlue,
    cardColor: Colors.white,
    canvasColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: navyBlue,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: navyBlue,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: Colors.white,
    cardColor: darkCard,
    canvasColor: const Color(0xFF1A1F3D).withOpacity(0.9),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: yellowDecorative,
        foregroundColor: darkBackground,
      ),
    ),
  );
}
