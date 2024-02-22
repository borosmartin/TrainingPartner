import 'package:equatable/equatable.dart';

class WorkoutSet extends Equatable {
  final num? repetitions;
  final num? weight;
  final num? distance;
  final num? duration;

  const WorkoutSet({
    this.repetitions,
    this.weight,
    this.distance,
    this.duration,
  });

  factory WorkoutSet.fromJson(Map<dynamic, dynamic> json) {
    return WorkoutSet(
      repetitions: json['repetitions'],
      weight: json['weight'],
      distance: json['distance'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'repetitions': repetitions,
      'weight': weight,
      'distance': distance,
      'duration': duration,
    };

    return json;
  }

  WorkoutSet copyWith({
    num? repetitions,
    num? weight,
    num? distance,
    num? duration,
  }) {
    return WorkoutSet(
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [repetitions, weight, distance, duration];
}
