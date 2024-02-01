import 'package:training_partner/features/home/data/service/workout_local_service.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class WorkoutRepository {
  final WorkoutServiceLocal _workoutServiceLocal;

  WorkoutRepository(this._workoutServiceLocal);

  Future<void> saveWorkoutSession(String email, WorkoutSession session) async {
    _workoutServiceLocal.saveWorkoutSession(email, session);
  }

  Future<List<WorkoutSession>> getAllSessionsFromHive() async {
    return await _workoutServiceLocal.getAllSessionsFromHive();
  }

  Future<void> deleteAllSessions() async {
    _workoutServiceLocal.deleteAllSessions();
  }
}
