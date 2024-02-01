import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExercisesUninitialized extends ExerciseState {}

class ExercisesLoading extends ExerciseState {}

class ExercisesLoaded extends ExerciseState {
  final List<Movement> movements;

  const ExercisesLoaded(this.movements);
}

class ExercisesError extends ExerciseState {
  final String errorMessage;

  const ExercisesError(this.errorMessage);
}
