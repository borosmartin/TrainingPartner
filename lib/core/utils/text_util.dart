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
}
