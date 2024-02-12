import 'package:training_partner/features/home/data/service/workout_local_service.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';

class WorkoutRepository {
  final WorkoutServiceLocal _workoutServiceLocal;

  WorkoutRepository(this._workoutServiceLocal);

  Future<void> saveWorkoutPlan(String email, WorkoutPlan workoutPlan) async {
    await _workoutServiceLocal.saveWorkoutPlan(email, workoutPlan);
  }

  Future<List<WorkoutPlan>> getAllWorkoutPlansFromHive(String email) async {
    return await _workoutServiceLocal.getAllWorkoutPlansFromHive(email);
  }

  Future<void> deleteWorkoutPlan(String email, WorkoutPlan workoutPlan) async {
    await _workoutServiceLocal.deleteWorkoutPlan(email, workoutPlan);
  }
}
