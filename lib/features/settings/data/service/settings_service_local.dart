import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';

class SettingsServiceLocal {
  static const String settingsBoxKey = 'SettingsBoxKey';

  Future<void> saveSettings(String email, AppSettings settings) async {
    final box = await Hive.openBox(settingsBoxKey);

    await box.put(email, settings.toJson());
  }

  Future<AppSettings> getSettings(String email) async {
    final box = await Hive.openBox(settingsBoxKey);

    var boxValue = box.get(email);

    if (boxValue == null) {
      return const AppSettings(
        theme: ThemeMode.system,
        weightUnit: WeightUnit.kg,
        distanceUnit: DistanceUnit.km,
        is24HourFormat: true,
        isSleepPrevented: false,
      );
    } else {
      return AppSettings.fromJson(boxValue);
    }
  }

  Future<void> deleteSettings(String email) async {
    final box = await Hive.openBox(settingsBoxKey);

    await box.delete(email);
  }
}
