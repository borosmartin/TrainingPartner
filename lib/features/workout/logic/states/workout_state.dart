import 'package:equatable/equatable.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class WorkoutUninitialized extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutSaved extends WorkoutState {
  final WorkoutSession session;

  WorkoutSaved({required this.session});

  @override
  List<Object?> get props => [session];
}

class WorkoutSessionsLoaded extends WorkoutState {
  final List<WorkoutSession> sessions;

  WorkoutSessionsLoaded({required this.sessions});

  @override
  List<Object?> get props => [sessions];
}

class WorkoutError extends WorkoutState {
  final String message;

  WorkoutError({required this.message});

  @override
  List<Object?> get props => [message];
}
