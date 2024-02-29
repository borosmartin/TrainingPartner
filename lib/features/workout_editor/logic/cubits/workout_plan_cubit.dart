import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/workout_editor/data/repository/workout_plan_repository.dart';
import 'package:training_partner/features/workout_editor/logic/states/workout_plan_states.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class WorkoutPlanCubit extends Cubit<WorkoutPlanState> {
  final WorkoutPlanRepository _workoutRepository;

  WorkoutPlanCubit(this._workoutRepository) : super(WorkoutPlansUninitialized());

  Future<void> saveWorkoutPlan(WorkoutPlan workoutPlan) async {
    try {
      emit(WorkoutPlanCreationLoading());

      await _workoutRepository.saveWorkoutPlan(currentUser.email!, workoutPlan);

      emit(WorkoutPlanCreationSuccessful(workoutPlan: workoutPlan));
    } catch (e) {
      emit(WorkoutPlanCreationError(message: e.toString()));
    }
  }

  Future<void> getAllWorkoutPlan() async {
    try {
      emit(WorkoutPlansLoading());

      List<WorkoutPlan> workoutPlans = await _workoutRepository.getAllWorkoutPlansFromHive(currentUser.email!);

      emit(WorkoutPlansLoaded(workoutPlans: workoutPlans));
    } catch (e) {
      emit(WorkoutPlanCreationError(message: e.toString()));
    }
  }

  Future<void> deleteWorkoutPlan(WorkoutPlan workoutPlan) async {
    try {
      emit(WorkoutPlanDeleteLoading());

      await _workoutRepository.deleteWorkoutPlan(currentUser.email!, workoutPlan);

      emit(WorkoutPlanDeleteSuccessful());
    } catch (e) {
      emit(WorkoutPlanCreationError(message: e.toString()));
    }
  }
}
