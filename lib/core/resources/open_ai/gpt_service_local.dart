import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/core/resources/open_ai/gpt_message.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class GptServiceLocal {
  static const String gptTipBoxKey = 'GptTipBoxKey';

  Future<void> saveWorkoutTip(String email, WorkoutPlan workoutPlan, GptMessage message) async {
    final box = await Hive.openBox(gptTipBoxKey);

    final json = message.toJson();
    final key = '$email - ${workoutPlan.name}';

    await box.put(key, json);
  }

  Future<GptMessage?> getGptTipFromHive(String email, WorkoutPlan workoutPlan) async {
    final box = await Hive.openBox(gptTipBoxKey);

    final key = '$email - ${workoutPlan.name}';
    final json = await box.get(key);

    if (json == null) {
      return null;
    } else {
      return GptMessage.fromJson(json);
    }
  }
}
