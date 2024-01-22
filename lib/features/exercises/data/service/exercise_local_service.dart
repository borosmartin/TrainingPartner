import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class ExerciseServiceLocal {
  static const String movementBoxKey = 'MovementBoxKey';
  static const String movementKey = 'MovementKey';

  Future<void> saveMovementData(MovementData movementData) async {
    final box = await Hive.openBox(movementBoxKey);

    await box.put(movementKey, movementData.toJson());
  }

  Future<MovementData?> getMovementDataFromHive() async {
    final box = await Hive.openBox(movementBoxKey);
    final boxValue = box.get(movementKey);

    if (boxValue != null) {
      final Map<String, dynamic> typedMap = Map<String, dynamic>.from(boxValue);
      return MovementData.fromJson(typedMap);
    } else {
      return null;
    }
  }
}
