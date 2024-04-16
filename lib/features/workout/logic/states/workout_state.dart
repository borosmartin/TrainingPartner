import 'package:equatable/equatable.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class WorkoutUninitialized extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutSessionsLoaded extends WorkoutState {
  final List<WorkoutSession> sessions;
  final bool isDeleted;
  final bool isCompleted;

  WorkoutSessionsLoaded({required this.sessions, this.isDeleted = false, this.isCompleted = false});

  @override
  List<Object?> get props => [sessions];
}

class WorkoutError extends WorkoutState {
  final String errorMessage;

  WorkoutError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
