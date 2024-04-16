import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

enum TextType {
  primary,
  secondary,
  tertiary,
  accent,
}

class CustomTextStyle {
  static TextStyle getCustomTextStyle({double? fontSize, FontWeight? fontWeight, Color? color}) {
    return TextStyle(
      fontFamily: 'Omnes',
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Colors.black,
      height: 0,
    );
  }

  static TextStyle _getTextStyle(BuildContext context, TextType type, {double? fontSize, FontWeight? fontWeight}) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;
    Color textColor;

    switch (type) {
      case TextType.primary:
        textColor = isLightTheme ? primaryTextColors[0] : primaryTextColors[1];
        break;
      case TextType.secondary:
        textColor = isLightTheme ? secondaryTextColors[0] : secondaryTextColors[1];
        break;
      case TextType.tertiary:
        textColor = Colors.white;
        break;
      case TextType.accent:
        textColor = accentColor;
        break;
    }

    return TextStyle(
      fontFamily: 'Omnes',
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: textColor,
    );
  }

  // ==================== B O D Y ==================== //
  static TextStyle bodyPrimary(BuildContext context) {
    return _getTextStyle(context, TextType.primary);
  }

  static TextStyle bodySecondary(BuildContext context) {
    return _getTextStyle(context, TextType.secondary);
  }

  static TextStyle bodyTetriary(BuildContext context) {
    return _getTextStyle(context, TextType.tertiary);
  }

  static TextStyle bodyAccent(BuildContext context) {
    return _getTextStyle(context, TextType.accent);
  }

  // ==================== B O D Y S M A L L ==================== //
  static TextStyle bodySmallPrimary(BuildContext context, {FontWeight? weight}) {
    return _getTextStyle(context, TextType.primary, fontSize: 16, fontWeight: weight ?? FontWeight.w600);
  }

  static TextStyle bodySmallSecondary(BuildContext context, {FontWeight? weight}) {
    return _getTextStyle(context, TextType.secondary, fontSize: 16, fontWeight: weight ?? FontWeight.w600);
  }

  static TextStyle bodySmallTetriary(BuildContext context, {FontWeight? weight}) {
    return _getTextStyle(context, TextType.tertiary, fontSize: 16, fontWeight: weight ?? FontWeight.w600);
  }

  static TextStyle bodySmallAccent(BuildContext context, {FontWeight? weight}) {
    return _getTextStyle(context, TextType.accent, fontSize: 16, fontWeight: weight ?? FontWeight.w600);
  }

  // ==================== S U B T I T L E ==================== //
  static TextStyle subtitlePrimary(BuildContext context) {
    return _getTextStyle(context, TextType.primary, fontSize: 20, fontWeight: FontWeight.w600);
  }

  static TextStyle subtitleSecondary(BuildContext context) {
    return _getTextStyle(context, TextType.secondary, fontSize: 20, fontWeight: FontWeight.w600);
  }

  static TextStyle subtitleTetriary(BuildContext context) {
    return _getTextStyle(context, TextType.tertiary, fontSize: 20, fontWeight: FontWeight.w600);
  }

  static TextStyle subtitleAccent(BuildContext context) {
    return _getTextStyle(context, TextType.accent, fontSize: 20, fontWeight: FontWeight.w600);
  }

  // ==================== T I T L E ==================== //
  static TextStyle titlePrimary(BuildContext context) {
    return _getTextStyle(context, TextType.primary, fontSize: 24, fontWeight: FontWeight.w700);
  }

  static TextStyle titleSecondary(BuildContext context) {
    return _getTextStyle(context, TextType.secondary, fontSize: 24, fontWeight: FontWeight.w700);
  }

  static TextStyle titleTetriary(BuildContext context) {
    return _getTextStyle(context, TextType.tertiary, fontSize: 24, fontWeight: FontWeight.w700);
  }

  static TextStyle titleAccent(BuildContext context) {
    return _getTextStyle(context, TextType.accent, fontSize: 24, fontWeight: FontWeight.w700);
  }
}
