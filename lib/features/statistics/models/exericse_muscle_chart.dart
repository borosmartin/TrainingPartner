import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
import 'package:training_partner/features/statistics/models/chart_options.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

Widget getExerciseMuscleChartYAxisValues(Chart chart, double chartValue, WeightUnit weightUnit, TextStyle textStyle) {
  switch (chart.chartOptions.muscleExerciseValueOption) {
    case ChartMuscleExerciseValueOption.repetitions:
      return Text(chartValue.toInt() == chartValue ? '${chartValue.toInt()}' : chartValue.toStringAsFixed(1), style: textStyle);
    case ChartMuscleExerciseValueOption.volume:
      if (weightUnit == WeightUnit.kg) {
        return Text(chartValue.toInt() > 1000 ? '${chartValue.toInt() / 1000} t' : '${chartValue.toInt()} kg', style: textStyle);
      } else {
        return Text(chartValue.toInt() > 2240 ? '${chartValue.toInt() / 2240} ton' : '${chartValue.toInt() * 2.20462} lbs', style: textStyle);
      }
    case ChartMuscleExerciseValueOption.weight:
      if (weightUnit == WeightUnit.kg) {
        return Text(chartValue.toInt() > 1000 ? '${chartValue.toInt() / 1000} t' : '${chartValue.toInt()} kg', style: textStyle);
      } else {
        return Text(chartValue.toInt() > 2240 ? '${chartValue.toInt() / 2240} ton' : '${chartValue.toInt() * 2.20462} lbs', style: textStyle);
      }
  }
}

LineTooltipItem getExerciseMuscleChartTooltip(BuildContext context, Chart chart, LineBarSpot spot, WeightUnit weightUnit) {
  switch (chart.chartOptions.muscleExerciseValueOption) {
    case ChartMuscleExerciseValueOption.repetitions:
      String text = '';
      if (spot.y.toInt() == spot.y) {
        if (spot.y.toInt() == 1) {
          text = '${spot.y.toInt()} rep';
        } else {
          text = '${spot.y.toInt()} reps';
        }
      } else {
        text = '${spot.y.toStringAsFixed(1)} reps';
      }

      return LineTooltipItem(text, CustomTextStyle.bodySmallSecondary(context));
    case ChartMuscleExerciseValueOption.volume:
      if (weightUnit == WeightUnit.kg) {
        return LineTooltipItem('${spot.y.toInt()} kg', CustomTextStyle.bodySmallTetriary(context));
      } else {
        return LineTooltipItem('${spot.y.toInt() * 2.20462} lbs', CustomTextStyle.bodySmallTetriary(context));
      }
    case ChartMuscleExerciseValueOption.weight:
      String text = '';
      if (spot.y.toInt() == spot.y) {
        if (weightUnit == WeightUnit.kg) {
          text = '${spot.y.toInt()} kg';
        } else {
          text = '${spot.y.toInt() * 2.20462} lbs';
        }
      } else {
        text = '${spot.y.toStringAsFixed(1)} kg';
        if (weightUnit == WeightUnit.kg) {
          text = '${spot.y.toInt()} kg';
        } else {
          text = '${spot.y.toInt() * 2.20462} lbs';
        }
      }

      return LineTooltipItem(text, CustomTextStyle.bodySmallTetriary(context));
  }
}

List<FlSpot> getExerciseMuscleChartSpots(Chart chart, List<WorkoutSession> previousSessions) {
  switch (chart.chartOptions.muscleExerciseValueOption) {
    case ChartMuscleExerciseValueOption.repetitions:
      switch (chart.chartOptions.progressOption) {
        case ChartProgressOption.lastWeek:
          return _getLastWeekReps(previousSessions, chart);
        case ChartProgressOption.lastMonth:
          return _getLastMonthReps(previousSessions, chart);
        case ChartProgressOption.lastYear:
          return _getLastYearReps(previousSessions, chart);
      }

    case ChartMuscleExerciseValueOption.volume:
      switch (chart.chartOptions.progressOption) {
        case ChartProgressOption.lastWeek:
          return _getLastWeekVolume(previousSessions, chart);
        case ChartProgressOption.lastMonth:
          return _getLastMonthVolume(previousSessions, chart);
        case ChartProgressOption.lastYear:
          return _getLastYearVolume(previousSessions, chart);
      }

    case ChartMuscleExerciseValueOption.weight:
      switch (chart.chartOptions.progressOption) {
        case ChartProgressOption.lastWeek:
          return _getLastWeekWeight(previousSessions, chart);
        case ChartProgressOption.lastMonth:
          return _getLastMonthWeight(previousSessions, chart);
        case ChartProgressOption.lastYear:
          return _getLastYearWeight(previousSessions, chart);
      }
  }
}

// ========================================= R E P E T I T I O N S ========================================= //

List<FlSpot> _getLastWeekReps(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];
  double xAxisPosition = 7;

  switch (chart.chartOptions.calculationOption) {
    case ChartCalculationOption.average:
      for (var date in DateTimeUtil.getLastWeek()) {
        num repCount = 0;
        num repSum = 0;

        for (WorkoutSession session in previousSessions) {
          if (DateTimeUtil.isSameDay(session.date!, date)) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      repSum += set.repetitions!;
                      repCount++;
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      repSum += set.repetitions!;
                      repCount++;
                    }
                  }
                }
              }
            }
          }
        }

        xAxisPosition -= 1;
        double averageReps = repCount > 0 ? repSum / repCount : 0;
        chartSpots.add(FlSpot(xAxisPosition, averageReps));
      }
      break;

    case ChartCalculationOption.best:
      for (var date in DateTimeUtil.getLastWeek()) {
        num bestRepCount = 0;

        for (WorkoutSession session in previousSessions) {
          if (DateTimeUtil.isSameDay(session.date!, date)) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      if (set.repetitions! > bestRepCount) {
                        bestRepCount = set.repetitions!;
                      }
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      if (set.repetitions! > bestRepCount) {
                        bestRepCount = set.repetitions!;
                      }
                    }
                  }
                }
              }
            }
          }
        }

        xAxisPosition -= 1;
        chartSpots.add(FlSpot(xAxisPosition.toDouble(), bestRepCount.toDouble()));
      }
      break;
  }

  return chartSpots;
}

List<FlSpot> _getLastMonthReps(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];

  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime startDate = now.subtract(const Duration(days: 34));

  switch (chart.chartOptions.calculationOption) {
    case ChartCalculationOption.average:
      for (int i = 4; i > 0; i--) {
        DateTime weekStart = startDate.add(Duration(days: i * 7));
        DateTime weekEnd = weekStart.add(const Duration(days: 6));

        num repCount = 0;
        num repSum = 0;

        for (WorkoutSession session in previousSessions) {
          DateTime workoutDate = session.date!;

          if ((workoutDate.isAfter(weekStart) || workoutDate.isAtSameMomentAs(weekStart)) &&
              (workoutDate.isBefore(weekEnd) || workoutDate.isAtSameMomentAs(weekEnd))) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      repSum += set.repetitions!;
                      repCount++;
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      repSum += set.repetitions!;
                      repCount++;
                    }
                  }
                }
              }
            }
          }
        }

        double averageReps = repCount > 0 ? repSum / repCount : 0;
        chartSpots.add(FlSpot(i.toDouble(), averageReps));
      }
      break;

    case ChartCalculationOption.best:
      for (int i = 4; i > 0; i--) {
        DateTime weekStart = startDate.add(Duration(days: i * 7));
        DateTime weekEnd = weekStart.add(const Duration(days: 6));

        num bestRepCount = 0;
        for (WorkoutSession session in previousSessions) {
          DateTime workoutDate = session.date!;

          if ((workoutDate.isAfter(weekStart) || workoutDate.isAtSameMomentAs(weekStart)) &&
              (workoutDate.isBefore(weekEnd) || workoutDate.isAtSameMomentAs(weekEnd))) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      if (set.repetitions! > bestRepCount) {
                        bestRepCount = set.repetitions!;
                      }
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      if (set.repetitions! > bestRepCount) {
                        bestRepCount = set.repetitions!;
                      }
                    }
                  }
                }
              }
            }
          }
        }

        chartSpots.add(FlSpot(i.toDouble(), bestRepCount.toDouble()));
      }
      break;
  }

  return chartSpots;
}

List<FlSpot> _getLastYearReps(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];
  DateTime now = DateTime.now();

  switch (chart.chartOptions.calculationOption) {
    case ChartCalculationOption.average:
      for (int i = 12; i > 0; i--) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        int daysInMonth = DateTime(now.year, now.month - i + 1, 0).day;
        DateTime monthEnd = DateTime(now.year, now.month - i, daysInMonth);

        num repCount = 0;
        num repSum = 0;

        for (WorkoutSession session in previousSessions) {
          DateTime workoutDate = session.date!;

          if (workoutDate.isAfter(monthStart) && workoutDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      repSum += set.repetitions!;
                      repCount++;
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      repSum += set.repetitions!;
                      repCount++;
                    }
                  }
                }
              }
            }
          }
        }

        double averageReps = repCount > 0 ? repSum / repCount : 0;
        chartSpots.add(FlSpot((13 - i).toDouble(), averageReps));
      }
      break;

    case ChartCalculationOption.best:
      for (int i = 12; i > 0; i--) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        int daysInMonth = DateTime(now.year, now.month - i + 1, 0).day;
        DateTime monthEnd = DateTime(now.year, now.month - i, daysInMonth);

        num bestRepCount = 0;
        for (WorkoutSession session in previousSessions) {
          DateTime workoutDate = session.date!;

          if (workoutDate.isAfter(monthStart) && workoutDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      if (set.repetitions! > bestRepCount) {
                        bestRepCount = set.repetitions!;
                      }
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      if (set.repetitions! > bestRepCount) {
                        bestRepCount = set.repetitions!;
                      }
                    }
                  }
                }
              }
            }
          }
        }

        chartSpots.add(FlSpot((13 - i).toDouble(), bestRepCount.toDouble()));
      }
      break;
  }

  return chartSpots;
}

// ========================================= V O L U M E ========================================= //

List<FlSpot> _getLastWeekVolume(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];
  double xAxisPosition = 7;

  for (var date in DateTimeUtil.getLastWeek()) {
    num totalVolume = 0;

    for (WorkoutSession session in previousSessions) {
      if (DateTimeUtil.isSameDay(session.date!, date)) {
        for (var exercise in session.exercises) {
          if (exercise.type == ExerciseType.repetitions) {
            if (chart.type == ChartBuilderChartType.exercise) {
              if (exercise.movement.id == chart.exerciseId) {
                for (var set in exercise.workoutSets) {
                  totalVolume += set.repetitions! * set.weight!;
                }
              }
            } else if (chart.type == ChartBuilderChartType.muscle) {
              if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                for (var set in exercise.workoutSets) {
                  totalVolume += set.repetitions! * set.weight!;
                }
              }
            }
          }
        }
      }
    }

    xAxisPosition -= 1;
    chartSpots.add(FlSpot(xAxisPosition, totalVolume.toDouble()));
  }

  return chartSpots;
}

List<FlSpot> _getLastMonthVolume(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];

  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime startDate = now.subtract(const Duration(days: 34));

  for (int i = 4; i > 0; i--) {
    DateTime weekStart = startDate.add(Duration(days: i * 7));
    DateTime weekEnd = weekStart.add(const Duration(days: 6));

    num totalVolume = 0;
    for (WorkoutSession session in previousSessions) {
      DateTime workoutDate = session.date!;

      if ((workoutDate.isAfter(weekStart) || workoutDate.isAtSameMomentAs(weekStart)) &&
          (workoutDate.isBefore(weekEnd) || workoutDate.isAtSameMomentAs(weekEnd))) {
        for (var exercise in session.exercises) {
          if (exercise.type == ExerciseType.repetitions) {
            if (chart.type == ChartBuilderChartType.exercise) {
              if (exercise.movement.id == chart.exerciseId) {
                for (var set in exercise.workoutSets) {
                  totalVolume += set.repetitions! * set.weight!;
                }
              }
            } else if (chart.type == ChartBuilderChartType.muscle) {
              if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                for (var set in exercise.workoutSets) {
                  totalVolume += set.repetitions! * set.weight!;
                }
              }
            }
          }
        }
      }
    }

    chartSpots.add(FlSpot(i.toDouble(), totalVolume.toDouble()));
  }

  return chartSpots;
}

List<FlSpot> _getLastYearVolume(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];
  DateTime now = DateTime.now();

  for (int i = 12; i > 0; i--) {
    DateTime monthStart = DateTime(now.year, now.month - i, 1);
    int daysInMonth = DateTime(now.year, now.month - i + 1, 0).day;
    DateTime monthEnd = DateTime(now.year, now.month - i, daysInMonth);

    num totalVolume = 0;
    for (WorkoutSession session in previousSessions) {
      DateTime workoutDate = session.date!;

      if (workoutDate.isAfter(monthStart) && workoutDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
        for (var exercise in session.exercises) {
          if (exercise.type == ExerciseType.repetitions) {
            if (chart.type == ChartBuilderChartType.exercise) {
              if (exercise.movement.id == chart.exerciseId) {
                for (var set in exercise.workoutSets) {
                  totalVolume += set.repetitions! * set.weight!;
                }
              }
            } else if (chart.type == ChartBuilderChartType.muscle) {
              if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                for (var set in exercise.workoutSets) {
                  totalVolume += set.repetitions! * set.weight!;
                }
              }
            }
          }
        }
      }
    }

    chartSpots.add(FlSpot((13 - i).toDouble(), totalVolume.toDouble()));
  }

  return chartSpots;
}

// ========================================= W E I G H T ========================================= //

List<FlSpot> _getLastWeekWeight(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];
  double xAxisPosition = 7;

  switch (chart.chartOptions.calculationOption) {
    case ChartCalculationOption.average:
      for (var date in DateTimeUtil.getLastWeek()) {
        num weightCount = 0;
        num weightSum = 0;

        for (WorkoutSession session in previousSessions) {
          if (DateTimeUtil.isSameDay(session.date!, date)) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      weightSum += set.repetitions!;
                      weightSum++;
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      weightSum += set.repetitions!;
                      weightSum++;
                    }
                  }
                }
              }
            }
          }
        }

        xAxisPosition -= 1;
        double averageWeight = weightCount > 0 ? weightSum / weightCount : 0;
        chartSpots.add(FlSpot(xAxisPosition, averageWeight));
      }
      break;

    case ChartCalculationOption.best:
      for (var date in DateTimeUtil.getLastWeek()) {
        num bestWeightValue = 0;

        for (WorkoutSession session in previousSessions) {
          if (DateTimeUtil.isSameDay(session.date!, date)) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      if (set.weight! > bestWeightValue) {
                        bestWeightValue = set.weight!;
                      }
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      if (set.weight! > bestWeightValue) {
                        bestWeightValue = set.weight!;
                      }
                    }
                  }
                }
              }
            }
          }
        }

        xAxisPosition -= 1;
        chartSpots.add(FlSpot(xAxisPosition, bestWeightValue.toDouble()));
      }
      break;
  }

  return chartSpots;
}

List<FlSpot> _getLastMonthWeight(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];

  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime startDate = now.subtract(const Duration(days: 34));

  switch (chart.chartOptions.calculationOption) {
    case ChartCalculationOption.average:
      for (int i = 4; i > 0; i--) {
        DateTime weekStart = startDate.add(Duration(days: i * 7));
        DateTime weekEnd = weekStart.add(const Duration(days: 6));

        num weightCount = 0;
        num weightSum = 0;

        for (WorkoutSession session in previousSessions) {
          DateTime workoutDate = session.date!;

          if ((workoutDate.isAfter(weekStart) || workoutDate.isAtSameMomentAs(weekStart)) &&
              (workoutDate.isBefore(weekEnd) || workoutDate.isAtSameMomentAs(weekEnd))) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      weightSum += set.weight!;
                      weightCount++;
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      weightSum += set.weight!;
                      weightCount++;
                    }
                  }
                }
              }
            }
          }
        }

        double averageWeight = weightCount > 0 ? weightSum / weightCount : 0;
        chartSpots.add(FlSpot(i.toDouble(), averageWeight));
      }
      break;

    case ChartCalculationOption.best:
      for (int i = 4; i > 0; i--) {
        DateTime weekStart = startDate.add(Duration(days: i * 7));
        DateTime weekEnd = weekStart.add(const Duration(days: 6));

        num bestWeightValue = 0;
        for (WorkoutSession session in previousSessions) {
          DateTime workoutDate = session.date!;

          if ((workoutDate.isAfter(weekStart) || workoutDate.isAtSameMomentAs(weekStart)) &&
              (workoutDate.isBefore(weekEnd) || workoutDate.isAtSameMomentAs(weekEnd))) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      if (set.weight! > bestWeightValue) {
                        bestWeightValue = set.weight!;
                      }
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      if (set.weight! > bestWeightValue) {
                        bestWeightValue = set.weight!;
                      }
                    }
                  }
                }
              }
            }
          }
        }

        chartSpots.add(FlSpot(i.toDouble(), bestWeightValue.toDouble()));
      }
      break;
  }

  return chartSpots;
}

List<FlSpot> _getLastYearWeight(List<WorkoutSession> previousSessions, Chart chart) {
  List<FlSpot> chartSpots = [];
  DateTime now = DateTime.now();

  switch (chart.chartOptions.calculationOption) {
    case ChartCalculationOption.average:
      for (int i = 12; i > 0; i--) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        int daysInMonth = DateTime(now.year, now.month - i + 1, 0).day;
        DateTime monthEnd = DateTime(now.year, now.month - i, daysInMonth);

        num weightCount = 0;
        num weightSum = 0;

        for (WorkoutSession session in previousSessions) {
          DateTime workoutDate = session.date!;

          if (workoutDate.isAfter(monthStart) && workoutDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      weightSum += set.weight!;
                      weightCount++;
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      weightSum += set.weight!;
                      weightCount++;
                    }
                  }
                }
              }
            }
          }
        }

        double averageWeight = weightCount > 0 ? weightSum / weightCount : 0;
        chartSpots.add(FlSpot((13 - i).toDouble(), averageWeight));
      }
      break;

    case ChartCalculationOption.best:
      for (int i = 12; i > 0; i--) {
        DateTime monthStart = DateTime(now.year, now.month - i, 1);
        int daysInMonth = DateTime(now.year, now.month - i + 1, 0).day;
        DateTime monthEnd = DateTime(now.year, now.month - i, daysInMonth);

        num bestWeightValue = 0;
        for (WorkoutSession session in previousSessions) {
          DateTime workoutDate = session.date!;

          if (workoutDate.isAfter(monthStart) && workoutDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
            for (var exercise in session.exercises) {
              if (exercise.type == ExerciseType.repetitions) {
                if (chart.type == ChartBuilderChartType.exercise) {
                  if (exercise.movement.id == chart.exerciseId) {
                    for (var set in exercise.workoutSets) {
                      if (set.weight! > bestWeightValue) {
                        bestWeightValue = set.weight!;
                      }
                    }
                  }
                } else if (chart.type == ChartBuilderChartType.muscle) {
                  if (exercise.movement.target.toLowerCase() == chart.muscleTarget!.toLowerCase()) {
                    for (var set in exercise.workoutSets) {
                      if (set.weight! > bestWeightValue) {
                        bestWeightValue = set.weight!;
                      }
                    }
                  }
                }
              }
            }
          }
        }

        chartSpots.add(FlSpot((13 - i).toDouble(), bestWeightValue.toDouble()));
      }
      break;
  }

  return chartSpots;
}
