import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.white,
    secondary: Colors.black26,
    tertiary: Colors.black87,
  ),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.white54,
    tertiary: Colors.white,
  ),
  cardColor: Colors.black26,
);
