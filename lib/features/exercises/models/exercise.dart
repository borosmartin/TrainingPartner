import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class Exercise extends Equatable {
  final Movement movement;
  final int? sets;
  final int? repetitions;
  final double? weight;
  final double? distance;
  final DateTime? duration;

  const Exercise({
    required this.movement,
    this.sets,
    this.repetitions,
    this.weight,
    this.distance,
    this.duration,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      movement: Movement.fromJson(json['movement']),
      sets: json['sets'],
      repetitions: json['repetitions'],
      weight: json['weight'],
      distance: json['distance'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movement': movement.toJson(),
      'sets': sets,
      'repetitions': repetitions,
      'weight': weight,
      'distance': distance,
      'duration': duration,
    };
  }

  @override
  List<Object?> get props => [movement, sets, repetitions, weight, distance, duration];
}
