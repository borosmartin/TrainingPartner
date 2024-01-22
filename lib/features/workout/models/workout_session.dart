import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class WorkoutSession extends Equatable {
  final String name;
  final List<Exercise> exercises;
  final DateTime date;
  const WorkoutSession({
    required this.name,
    required this.exercises,
    required this.date,
  });

  @override
  List<Object?> get props => [name, exercises, date];
}
