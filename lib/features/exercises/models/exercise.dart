import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/exercises/models/workout_set.dart';

enum ExerciseType { repetitions, distance, duration }

class Exercise extends Equatable {
  final Movement movement;
  final ExerciseType type;
  final List<WorkoutSet> workoutSets;

  const Exercise({
    required this.movement,
    required this.type,
    required this.workoutSets,
  });

  Exercise copyWith({
    Movement? movement,
    ExerciseType? exerciseType,
    List<WorkoutSet>? workoutSets,
  }) {
    return Exercise(
      movement: movement ?? this.movement,
      type: exerciseType ?? type,
      workoutSets: workoutSets ?? this.workoutSets,
    );
  }

  factory Exercise.fromJson(Map json) {
    List<WorkoutSet> workoutSets = (json['workoutSets'] as List).map((workoutSetJson) => WorkoutSet.fromJson(workoutSetJson)).toList();

    ExerciseType type;
    if (json['exerciseType'] == 'ExerciseType.repetitions') {
      type = ExerciseType.repetitions;
    } else if (json['exerciseType'] == 'ExerciseType.distance') {
      type = ExerciseType.distance;
    } else {
      type = ExerciseType.duration;
    }

    return Exercise(
      movement: Movement.fromJson(json['movement']),
      type: type,
      workoutSets: workoutSets,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'movement': movement.toJson(),
      'exerciseType': type.toString(),
      'workoutSets': workoutSets.map((set) => set.toJson()).toList(),
    };

    return json;
  }

  @override
  List<Object?> get props => [movement, type, workoutSets];
}
