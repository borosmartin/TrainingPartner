import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class UninitializedExercises extends ExerciseState {}

class LoadingExercises extends ExerciseState {}

class LoadedExercises extends ExerciseState {
  final List<Exercise> exercises;

  const LoadedExercises(this.exercises);
}

class ErrorExercises extends ExerciseState {
  final String errorMessage;

  const ErrorExercises(this.errorMessage);
}
