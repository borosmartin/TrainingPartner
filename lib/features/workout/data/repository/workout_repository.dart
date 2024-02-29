import 'package:training_partner/features/workout/data/service/workout_service_local.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutRepository {
  final WorkoutServiceLocal _workoutServiceLocal;

  WorkoutRepository(this._workoutServiceLocal);

  Future<void> saveWorkoutSession(String email, WorkoutSession workoutSession) async {
    await _workoutServiceLocal.saveWorkoutSession(email, workoutSession);
  }

  Future<List<WorkoutSession>> getAllWorkoutSession(String email) async {
    return await _workoutServiceLocal.getAllWorkoutSession(email);
  }
}
