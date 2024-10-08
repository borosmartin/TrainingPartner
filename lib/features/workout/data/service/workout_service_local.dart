import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutServiceLocal {
  static const String workoutBoxKey = 'WorkoutBoxKey';

  Future<void> saveWorkoutSession(String email, WorkoutSession workoutSession) async {
    final box = await Hive.openBox(workoutBoxKey);

    final String key = '$email-${workoutSession.id}-${workoutSession.date}';
    await box.put(key, workoutSession.toJson());
  }

  Future<void> deleteWorkoutSession(String email, WorkoutSession workoutSession) async {
    final box = await Hive.openBox(workoutBoxKey);

    final String key = '$email-${workoutSession.id}-${workoutSession.date}';

    await box.delete(key);
  }

  Future<List<WorkoutSession>> getAllPreviousWorkout(String email) async {
    final box = await Hive.openBox(workoutBoxKey);
    // box.clear();

    final jsonList = box.keys.where((key) => key.startsWith(email));
    final List<WorkoutSession> sessions = [];

    for (var key in jsonList) {
      final json = await box.get(key);
      final session = WorkoutSession.fromJson(json);
      sessions.add(session);
    }

    return sessions;
  }
}
