import 'package:flutter/material.dart';

// background: Color.fromRGBO(230, 217, 200, 1),
// primary: Color.fromRGBO(240, 236, 227, 1),
// secondary: Color.fromRGBO(199, 177, 152, 1),
// tertiary: Color.fromRGBO(89, 110, 151, 1),
ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color.fromRGBO(0, 173, 181, 1),
    selectionColor: Color.fromRGBO(0, 173, 181, 1),
    selectionHandleColor: Color.fromRGBO(0, 173, 181, 1),
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.white,
    secondary: const Color.fromRGBO(199, 177, 152, 1),
    tertiary: const Color.fromRGBO(0, 173, 181, 1),
  ),
);
