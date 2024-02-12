import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/home/data/repository/workout_repository.dart';
import 'package:training_partner/features/home/logic/states/workout_states.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _workoutRepository;

  WorkoutCubit(this._workoutRepository) : super(WorkoutsUninitialized());

  Future<void> saveWorkoutPlan(WorkoutPlan workoutPlan) async {
    try {
      emit(WorkoutPlanCreationLoading());

      await _workoutRepository.saveWorkoutPlan(currentUser.email!, workoutPlan);

      emit(WorkoutPlanCreationSuccessful(workoutPlan: workoutPlan));
    } catch (e) {
      emit(WorkoutPlanCreationError(message: e.toString()));
    }
  }

  Future<void> getAllWorkoutPlans() async {
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
