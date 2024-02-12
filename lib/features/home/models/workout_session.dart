import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class WorkoutSession extends Equatable {
  final String id;
  final String name;
  final List<Exercise> exercises;

  const WorkoutSession({
    required this.id,
    required this.name,
    required this.exercises,
  });

  WorkoutSession copyWith({
    String? id,
    String? name,
    List<Exercise>? exercises,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
    );
  }

  factory WorkoutSession.fromJson(Map json) {
    List<Exercise> exercises = (json['exercises'] as List).map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList();

    return WorkoutSession(
      id: json['id'],
      name: json['name'],
      exercises: exercises,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
    };

    return json;
  }

  @override
  List<Object?> get props => [id, name, exercises];
}
