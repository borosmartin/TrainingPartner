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

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'],
      name: json['name'],
      exercises: json['exercises'].map<Exercise>((exercise) => Exercise.fromJson(exercise)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name, exercises];
}
