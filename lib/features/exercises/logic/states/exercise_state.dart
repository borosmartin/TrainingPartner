import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout_editor/models/movement_filter.dart';

class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExercisesUninitialized extends ExerciseState {}

class MovementsLoading extends ExerciseState {}

class MovementsLoaded extends ExerciseState {
  final List<Movement> movements;
  final List<Movement>? filteredMovements;
  final MovementFilter? previousFilter;

  const MovementsLoaded({required this.movements, this.filteredMovements, this.previousFilter});

  @override
  List<Object?> get props => [movements, previousFilter];
}

class MovementsError extends ExerciseState {
  final String errorMessage;

  const MovementsError(this.errorMessage);
}
