import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum WeightUnit { kg, lbs }

enum DistanceUnit { km, miles }

class AppSettings extends Equatable {
  final ThemeMode theme;
  final WeightUnit weightUnit;
  final DistanceUnit distanceUnit;
  final bool isSleepPrevented;
  final bool is24HourFormat;

  const AppSettings({
    required this.theme,
    required this.weightUnit,
    required this.distanceUnit,
    required this.isSleepPrevented,
    required this.is24HourFormat,
  });

  AppSettings copyWith({
    ThemeMode? theme,
    WeightUnit? weightUnit,
    DistanceUnit? distanceUnit,
    bool? isSleepPrevented,
    bool? is24HourFormat,
  }) {
    return AppSettings(
      theme: theme ?? this.theme,
      weightUnit: weightUnit ?? this.weightUnit,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      isSleepPrevented: isSleepPrevented ?? this.isSleepPrevented,
      is24HourFormat: is24HourFormat ?? this.is24HourFormat,
    );
  }

  factory AppSettings.fromJson(Map<dynamic, dynamic> json) {
    return AppSettings(
      theme: ThemeMode.values.firstWhere((element) => element.toString() == json['theme']),
      weightUnit: WeightUnit.values.firstWhere((element) => element.toString() == json['weightUnit']),
      distanceUnit: DistanceUnit.values.firstWhere((element) => element.toString() == json['distanceUnit']),
      isSleepPrevented: json['isSleepPrevented'],
      is24HourFormat: json['is24HourFormat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme.toString(),
      'weightUnit': weightUnit.toString(),
      'distanceUnit': distanceUnit.toString(),
      'isSleepPrevented': isSleepPrevented,
      'is24HourFormat': is24HourFormat,
    };
  }

  @override
  List<Object> get props => [theme, weightUnit, distanceUnit, isSleepPrevented, is24HourFormat];
}
