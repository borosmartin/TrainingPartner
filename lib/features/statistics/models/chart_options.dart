import 'package:equatable/equatable.dart';

enum ChartProgressOption { lastWeek, lastMonth, lastYear }

enum ChartWorkoutValueOption { amount, duration, volume }

enum ChartMuscleExerciseValueOption { weight, repetitions, volume }

enum ChartCalculationOption { best, average }

class ChartOptions extends Equatable {
  final ChartProgressOption progressOption;
  final ChartWorkoutValueOption workoutValueOption;
  final ChartMuscleExerciseValueOption muscleExerciseValueOption;
  final ChartCalculationOption calculationOption;

  String get progressOptionString => _getProgressOptionString();

  const ChartOptions({
    this.progressOption = ChartProgressOption.lastMonth,
    this.workoutValueOption = ChartWorkoutValueOption.duration,
    this.muscleExerciseValueOption = ChartMuscleExerciseValueOption.volume,
    this.calculationOption = ChartCalculationOption.best,
  });

  ChartOptions copyWith({
    ChartProgressOption? progressOption,
    ChartWorkoutValueOption? workoutValueOption,
    ChartMuscleExerciseValueOption? muscleExerciseValueOption,
    ChartCalculationOption? calculationOption,
  }) {
    return ChartOptions(
      progressOption: progressOption ?? this.progressOption,
      workoutValueOption: workoutValueOption ?? this.workoutValueOption,
      muscleExerciseValueOption: muscleExerciseValueOption ?? this.muscleExerciseValueOption,
      calculationOption: calculationOption ?? this.calculationOption,
    );
  }

  factory ChartOptions.fromJson(dynamic json) {
    return ChartOptions(
      progressOption: ChartProgressOption.values.firstWhere((e) => e.toString() == json['progressOption']),
      workoutValueOption: ChartWorkoutValueOption.values.firstWhere((e) => e.toString() == json['workoutValueOption']),
      muscleExerciseValueOption: ChartMuscleExerciseValueOption.values.firstWhere((e) => e.toString() == json['muscleExerciseValueOption']),
      calculationOption: ChartCalculationOption.values.firstWhere((e) => e.toString() == json['calculationOption']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'progressOption': progressOption.toString(),
      'workoutValueOption': workoutValueOption.toString(),
      'muscleExerciseValueOption': muscleExerciseValueOption.toString(),
      'calculationOption': calculationOption.toString(),
    };
  }

  String _getProgressOptionString() {
    switch (progressOption) {
      case ChartProgressOption.lastWeek:
        return 'Last week';
      case ChartProgressOption.lastMonth:
        return 'Last month';
      case ChartProgressOption.lastYear:
        return 'Last year';
    }
  }

  @override
  List<Object?> get props => [progressOption, workoutValueOption, muscleExerciseValueOption, calculationOption];
}
