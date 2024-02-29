import 'package:training_partner/features/workout_editor/data/service/workout_plan_local_service.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class WorkoutPlanRepository {
  final WorkoutPlanServiceLocal _workoutServiceLocal;

  WorkoutPlanRepository(this._workoutServiceLocal);

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
