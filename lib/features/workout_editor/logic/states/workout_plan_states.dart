import 'package:equatable/equatable.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class WorkoutPlanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorkoutPlansUninitialized extends WorkoutPlanState {}

class WorkoutPlansLoading extends WorkoutPlanState {}

class WorkoutPlansLoaded extends WorkoutPlanState {
  final List<WorkoutPlan> workoutPlans;

  WorkoutPlansLoaded({required this.workoutPlans});

  @override
  List<Object?> get props => [workoutPlans];
}

class WorkoutPlansError extends WorkoutPlanState {
  final String message;

  WorkoutPlansError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Create

class WorkoutPlanCreationLoading extends WorkoutPlanState {}

class WorkoutPlanCreationSuccessful extends WorkoutPlanState {
  final WorkoutPlan workoutPlan;

  WorkoutPlanCreationSuccessful({required this.workoutPlan});

  @override
  List<Object?> get props => [workoutPlan];
}

class WorkoutPlanCreationError extends WorkoutPlanState {
  final String message;

  WorkoutPlanCreationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Delete

class WorkoutPlanDeleteLoading extends WorkoutPlanState {}

class WorkoutPlanDeleteSuccessful extends WorkoutPlanState {}

class WorkoutPlanDeleteError extends WorkoutPlanState {
  final String message;

  WorkoutPlanDeleteError({required this.message});

  @override
  List<Object?> get props => [message];
}
