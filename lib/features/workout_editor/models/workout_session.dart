import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class WorkoutSession extends Equatable {
  final String id;
  final String name;
  final num? durationInSeconds;
  final DateTime? date;
  final List<Exercise> exercises;

  const WorkoutSession({
    required this.id,
    required this.name,
    this.durationInSeconds,
    this.date,
    required this.exercises,
  });

  WorkoutSession copyWith({
    String? id,
    String? name,
    num? durationInSeconds,
    DateTime? date,
    List<Exercise>? exercises,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      name: name ?? this.name,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      date: date ?? this.date,
      exercises: exercises ?? this.exercises,
    );
  }

  factory WorkoutSession.fromJson(Map json) {
    List<Exercise> exercises = (json['exercises'] as List).map((exerciseJson) => Exercise.fromJson(exerciseJson)).toList();

    return WorkoutSession(
      id: json['id'],
      name: json['name'],
      durationInSeconds: json['durationInSeconds'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      exercises: exercises,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'durationInSeconds': durationInSeconds,
      'date': date?.toIso8601String(),
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
    };

    return json;
  }

  @override
  List<Object?> get props => [id, name, durationInSeconds, exercises];
}
