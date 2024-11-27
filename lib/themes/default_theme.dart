import 'package:flutter/material.dart';

class DefaultTheme {
  static const Color primary = Colors.grey; // Color gris para títulos y botones
  static const Color secondary =
      Colors.grey; // Color para componentes secundarios
  static const Color textPrimary =
      Color.fromARGB(255, 134, 133, 133); // Gris claro para textos
  static const Color backgroundLight = Color.fromARGB(255, 245, 245, 245);
  static const Color backgroundDark = Color.fromARGB(255, 30, 30, 30);

  static const String fontFamily = 'assets/fonts/OoohBaby-regular.ttf';

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: primary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: primary,
        fontWeight: FontWeight.bold,
        fontSize: 25,
        fontFamily: fontFamily,
      ),
    ),
    scaffoldBackgroundColor: backgroundLight,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        color: primary,
        fontSize: 16,
        fontFamily: fontFamily,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardTheme(
      color: backgroundLight,
      shadowColor: primary,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    listTileTheme: const ListTileThemeData(iconColor: primary),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: const TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: primary,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: primary,
        fontWeight: FontWeight.bold,
        fontSize: 25,
        fontFamily: fontFamily,
      ),
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        color: primary,
        fontSize: 16,
        fontFamily: fontFamily,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardTheme(
      color: backgroundDark,
      shadowColor: primary,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    listTileTheme: const ListTileThemeData(iconColor: primary),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: const TextStyle(color: primary),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
