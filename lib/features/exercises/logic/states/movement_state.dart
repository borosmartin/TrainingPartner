import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout_editor/models/movement_filter.dart';

class MovementState extends Equatable {
  const MovementState();

  @override
  List<Object?> get props => [];
}

class MovementsUninitialized extends MovementState {}

class MovementsLoading extends MovementState {}

class MovementsLoaded extends MovementState {
  final List<Movement> movements;
  final List<Movement>? filteredMovements;
  final MovementFilter? previousFilter;

  const MovementsLoaded({required this.movements, this.filteredMovements, this.previousFilter});

  @override
  List<Object?> get props => [movements, previousFilter];
}

class MovementsError extends MovementState {
  final String errorMessage;

  const MovementsError(this.errorMessage);
}
