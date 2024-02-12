import 'package:equatable/equatable.dart';

class WorkoutSet extends Equatable {
  final int? repetitions;
  final int? weight;
  final int? distance;
  final int? duration;

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

  @override
  List<Object?> get props => [repetitions, weight, distance, duration];
}
