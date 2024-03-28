import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/workout_editor/data/service/workout_plan_local_service.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class WorkoutPlanRepository {
  final WorkoutPlanServiceLocal _workoutServiceLocal;

  WorkoutPlanRepository(this._workoutServiceLocal);

  Future<void> createWorkoutPlan(String email, WorkoutPlan workoutPlan) async {
    try {
      await fireStore.collection('workout_plans').doc('$email - ${workoutPlan.name}').set(workoutPlan.toJson());

      await _workoutServiceLocal.saveWorkoutPlan(email, workoutPlan);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WorkoutPlan>> getAllWorkoutPlan(String email) async {
    try {
      List<WorkoutPlan> workoutPlans = [];

      await fireStore.collection('workout_plans').get().then((snapShot) {
        for (var plan in snapShot.docs) {
          if (plan.id.contains(email)) {
            workoutPlans.add(WorkoutPlan.fromJson(plan.data()));
          }
        }
      });

      return workoutPlans;
    } catch (e) {
      try {
        return await _workoutServiceLocal.getAllWorkoutPlansFromHive(email);
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteWorkoutPlan(String email, WorkoutPlan workoutPlan) async {
    try {
      await fireStore.collection('workout_plans').doc('$email - ${workoutPlan.name}').delete();

      await _workoutServiceLocal.deleteWorkoutPlan(email, workoutPlan);
    } catch (e) {
      rethrow;
    }
  }
}
