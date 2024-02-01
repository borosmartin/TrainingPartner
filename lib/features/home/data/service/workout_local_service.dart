import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class WorkoutServiceLocal {
  static const String editorBoxKey = 'EditorBoxKey';
  static const String sessionKey = 'SessionKey';

  Future<void> saveWorkoutSession(String email, WorkoutSession session) async {
    final box = await Hive.openBox(editorBoxKey);

    final key = '$sessionKey-$email-${session.id}';

    await box.put(key, session.toJson());
  }

  Future<List<WorkoutSession>> getAllSessionsFromHive() async {
    final box = await Hive.openBox(editorBoxKey);

    List<WorkoutSession> sessions = [];

    for (var i = 0; i < box.length; i++) {
      final dynamic key = box.keyAt(i);
      if (key != null && key.toString().startsWith(sessionKey)) {
        final sessionJson = box.get(key);
        if (sessionJson != null) {
          final session = WorkoutSession.fromJson(sessionJson);
          sessions.add(session);
        }
      }
    }

    return sessions;
  }

  Future<void> deleteAllSessions() async {
    final box = await Hive.openBox(editorBoxKey);

    box.clear();
  }
}
