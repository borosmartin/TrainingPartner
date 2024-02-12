import 'package:equatable/equatable.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';

class WorkoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WorkoutsUninitialized extends WorkoutState {}

class WorkoutPlansLoading extends WorkoutState {}

class WorkoutPlansLoaded extends WorkoutState {
  final List<WorkoutPlan> workoutPlans;

  WorkoutPlansLoaded({required this.workoutPlans});

  @override
  List<Object?> get props => [workoutPlans];
}

class WorkoutPlansError extends WorkoutState {
  final String message;

  WorkoutPlansError({required this.message});

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

class WorkoutPlanDeleteSuccessful extends WorkoutState {}

class WorkoutPlanDeleteError extends WorkoutState {
  final String message;

  WorkoutPlanDeleteError({required this.message});

  @override
  List<Object?> get props => [message];
}
