import 'package:equatable/equatable.dart';
import 'package:training_partner/features/workout/models/workout_plan.dart';

class WorkoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorkoutsUninitialized extends WorkoutState {}

class WorkoutsLoading extends WorkoutState {}

class WorkoutsLoaded extends WorkoutState {
  final List<WorkoutPlan> workoutPlans;
  final WorkoutPlan activeWorkoutPlan;

  WorkoutsLoaded({required this.workoutPlans, required this.activeWorkoutPlan});

  @override
  List<Object?> get props => [workoutPlans];
}

class WorkoutsError extends WorkoutState {
  final String message;

  WorkoutsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Create

class WorkoutPlanCreationLoading extends WorkoutState {}

class WorkoutPlanCreationSuccessful extends WorkoutState {
  final WorkoutPlan workoutPlan;

  WorkoutPlanCreationSuccessful({required this.workoutPlan});

  @override
  List<Object?> get props => [workoutPlan];
}

class WorkoutPlanCreationError extends WorkoutState {
  final String message;

  WorkoutPlanCreationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Delete

class WorkoutPlanDeleteLoading extends WorkoutState {}

class WorkoutPlanDeleteSuccessful extends WorkoutState {
  final WorkoutPlan workoutPlan;

  WorkoutPlanDeleteSuccessful({required this.workoutPlan});

  @override
  List<Object?> get props => [workoutPlan];
}

class WorkoutPlanDeleteError extends WorkoutState {
  final String message;

  WorkoutPlanDeleteError({required this.message});

  @override
  List<Object?> get props => [message];
}
