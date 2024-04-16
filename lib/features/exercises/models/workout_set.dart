import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';

class WorkoutSet extends Equatable {
  final num? repetitions;
  final num? weight;
  final WeightUnit? weightUnit;
  final num? distance;
  final DistanceUnit? distanceUnit;
  final num? duration;

  const WorkoutSet({
    this.repetitions,
    this.weight,
    this.weightUnit,
    this.distance,
    this.distanceUnit,
    this.duration,
  });

  factory WorkoutSet.fromJson(Map<dynamic, dynamic> json) {
    return WorkoutSet(
      repetitions: json['repetitions'],
      weight: json['weight'],
      weightUnit: WeightUnit.values.firstWhereOrNull((element) => element.toString() == json['weightUnit']),
      distance: json['distance'],
      distanceUnit: DistanceUnit.values.firstWhereOrNull((element) => element.toString() == json['distanceUnit']),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'repetitions': repetitions,
      'weight': weight,
      'weightUnit': weightUnit?.toString(),
      'distance': distance,
      'distanceUnit': distanceUnit?.toString(),
      'duration': duration,
    };

    return json;
  }

  WorkoutSet copyWith({
    num? repetitions,
    num? weight,
    WeightUnit? weightUnit,
    num? distance,
    DistanceUnit? distanceUnit,
    num? duration,
  }) {
    return WorkoutSet(
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      distance: distance ?? this.distance,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [repetitions, weight, weightUnit, distance, distanceUnit, duration];
}
