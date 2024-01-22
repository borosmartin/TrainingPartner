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

  @override
  List<Object?> get props => [movement, sets, repetitions, weight, distance, duration];
}
