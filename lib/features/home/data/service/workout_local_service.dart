import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';

class WorkoutServiceLocal {
  static const String workoutBoxKey = 'WorkoutBoxKey';

  Future<void> saveWorkoutPlan(String email, WorkoutPlan workoutPlan) async {
    final box = await Hive.openBox(workoutBoxKey);

    final json = workoutPlan.toJson();
    final key = '$email - ${workoutPlan.name}';

    await box.put(key, json);
  }

  Future<List<WorkoutPlan>> getAllWorkoutPlansFromHive(String email) async {
    final box = await Hive.openBox(workoutBoxKey);

    final jsonList = box.keys.where((key) => key.startsWith(email));
    final List<WorkoutPlan> plans = [];

    for (var key in jsonList) {
      final jsonPlan = await box.get(key);
      final plan = WorkoutPlan.fromJson(jsonPlan);
      plans.add(plan);
    }

    return plans;
  }

  Future<void> deleteWorkoutPlan(String email, WorkoutPlan workoutPlan) async {
    final box = await Hive.openBox(workoutBoxKey);

    final key = '$email - ${workoutPlan.name}';

    await box.delete(key);
  }
}
