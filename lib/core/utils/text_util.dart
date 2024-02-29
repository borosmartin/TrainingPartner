import 'package:flutter/material.dart';

class TextUtil {
  static String firstLetterToUpperCase(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatTimeToDigitalFormat(int? seconds) {
    if (seconds == null) {
      return '';
    }

    final hours = seconds ~/ 3600;
    final minutes = (seconds ~/ 60) % 60;
    final remainingSeconds = seconds % 60;

    String hoursStr = (hours > 0) ? '${hours.toString().padLeft(2, '0')}:' : '';
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr:$secondsStr';
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
