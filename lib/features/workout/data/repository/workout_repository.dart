import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/workout/data/service/workout_service_local.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutRepository {
  final WorkoutServiceLocal _workoutServiceLocal;

  WorkoutRepository(this._workoutServiceLocal);

  Future<void> saveWorkoutSession(String email, WorkoutSession workoutSession) async {
    try {
      await fireStore.collection('workout_sessions').doc('$email - ${workoutSession.id} - ${workoutSession.date}').set(workoutSession.toJson());

      await _workoutServiceLocal.saveWorkoutSession(email, workoutSession);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WorkoutSession>> getAllPreviousWorkouts(String email) async {
    try {
      List<WorkoutSession> sessions = [];

      await fireStore.collection('workout_sessions').get().then((snapShot) {
        for (var session in snapShot.docs) {
          if (session.id.contains(email)) {
            sessions.add(WorkoutSession.fromJson(session.data()));
          }
        }
      });

      return sessions;
    } catch (e) {
      try {
        return await _workoutServiceLocal.getAllPreviousWorkout(email);
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteWorkoutSession(String email, WorkoutSession workoutSession) async {
    try {
      await fireStore.collection('workout_sessions').doc('$email - ${workoutSession.id} - ${workoutSession.date}').delete();

      await _workoutServiceLocal.deleteWorkoutSession(email, workoutSession);
    } catch (e) {
      rethrow;
    }
  }
}
