import 'dart:math';

import 'package:training_partner/features/settings/model/app_settings.dart';

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

  static String getWeightStringWithUnit({required num weight, required WeightUnit setUnit, required WeightUnit settingsUnit}) {
    String result = '';

    String unitString = settingsUnit == WeightUnit.kg ? 'kg' : 'lb';

    if (setUnit == settingsUnit) {
      if (weight % 1 == 0) {
        result = '${weight.toStringAsFixed(0)} $unitString';
      } else {
        result = '${weight.toString()} $unitString';
      }
    } else {
      if (setUnit == WeightUnit.kg && settingsUnit == WeightUnit.lbs) {
        result = '${weight * 2.20462} $unitString';
      }

      if (setUnit == WeightUnit.lbs && settingsUnit == WeightUnit.kg) {
        result = '${weight / 2.20462} $unitString';
      }
    }

    return result;
  }

  static String getDistanceStringWithUnit({required num distance, required DistanceUnit setUnit, required DistanceUnit settingsUnit}) {
    String result = '';

    String unitString = settingsUnit == DistanceUnit.km ? 'km' : 'miles';

    if (setUnit == settingsUnit) {
      result = '${distance.toString()} $unitString';
    } else {
      if (setUnit == DistanceUnit.km && settingsUnit == DistanceUnit.miles) {
        result = '${distance * 0.621371} $unitString';
      }

      if (setUnit == DistanceUnit.miles && settingsUnit == DistanceUnit.km) {
        result = '${distance / 0.621371} $unitString';
      }
    }

    return result;
  }
}
