import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/features/workout/logic/states/workout_states.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  WorkoutCubit() : super(WorkoutsUninitialized());

  Future<void> loadWorkoutPlans() async {}

  Future<void> createWorkoutPlan() async {}
}
