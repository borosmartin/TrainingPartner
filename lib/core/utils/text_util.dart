import 'dart:math';

import 'package:flutter/material.dart';

class TextUtil {
  static String firstLetterToUpperCase(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  static String numToString(num number) {
    if (number % 1 == 0) {
      return number.toStringAsFixed(0);
    } else {
      return number.toString();
    }
  }

  static TextStyle getCustomTextStyle({double? fontSize, FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontFamily: 'Omnes',
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.black,
    );
  }

  static String generateUniqueId(List<String> existingIds) {
    Random random = Random();
    bool isUnique = false;
    int newId = 0;

    while (!isUnique) {
      newId = 100 + random.nextInt(900);
      String newIdString = newId.toString();

      if (!existingIds.contains(newIdString)) {
        isUnique = true;
      }
    }

    return newId.toString();
  }
}
