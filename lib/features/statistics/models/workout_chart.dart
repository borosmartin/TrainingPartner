import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
import 'package:training_partner/features/statistics/models/chart_options.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

Widget getWorkoutChartYAxisValues(Chart chart, double chartValue, WeightUnit weightUnit, TextStyle textStyle) {
  switch (chart.chartOptions.workoutValueOption) {
    case ChartWorkoutValueOption.amount:
      return Text('${chartValue.toInt()}', style: textStyle);
    case ChartWorkoutValueOption.duration:
      return Text(
          chartValue.toInt() == chartValue
              ? '${chartValue.toInt()} hrs'
              : chartValue.toInt() == 1
                  ? '${chartValue.toInt()} hr'
                  : '${chartValue.toStringAsFixed(1)} hrs',
          style: textStyle,
          textAlign: TextAlign.left);
    case ChartWorkoutValueOption.volume:
      if (weightUnit == WeightUnit.kg) {
        return Text(chartValue.toInt() > 1000 ? '${chartValue.toInt() / 1000} t' : '${chartValue.toInt()} kg', style: textStyle);
      } else {
        return Text(chartValue.toInt() > 2240 ? '${chartValue.toInt() / 2240} ton' : '${chartValue.toInt() * 2.20462} lbs', style: textStyle);
      }
  }
}

LineTooltipItem getWorkoutChartTooltip(BuildContext context, Chart chart, LineBarSpot spot, WeightUnit weightUnit) {
  switch (chart.chartOptions.workoutValueOption) {
    case ChartWorkoutValueOption.amount:
      return LineTooltipItem('${spot.y.toInt()} workouts', CustomTextStyle.bodySmallTetriary(context));
    case ChartWorkoutValueOption.duration:
      return LineTooltipItem(DateTimeUtil.secondsToTextTime((spot.y * 3600).toInt()), CustomTextStyle.bodySmallTetriary(context));
    case ChartWorkoutValueOption.volume:
      if (weightUnit == WeightUnit.kg) {
        return LineTooltipItem('${spot.y.toInt()} kg', CustomTextStyle.bodySmallTetriary(context));
      } else {
        return LineTooltipItem('${spot.y.toInt() * 2.20462} lbs', CustomTextStyle.bodySmallTetriary(context));
      }
  }
}

List<FlSpot> getWorkoutChartSpots(Chart chart, List<WorkoutSession> previousSessions) {
  switch (chart.chartOptions.workoutValueOption) {
    case ChartWorkoutValueOption.amount:
      switch (chart.chartOptions.progressOption) {
        case ChartProgressOption.lastWeek:
          return _getLastWeekAmount(previousSessions);
        case ChartProgressOption.lastMonth:
          return _getLastMonthAmount(previousSessions);
        case ChartProgressOption.lastYear:
          return _getLastYearAmount(previousSessions);
      }

    case ChartWorkoutValueOption.duration:
      switch (chart.chartOptions.progressOption) {
        case ChartProgressOption.lastWeek:
          return _getLastWeekDuration(previousSessions);
        case ChartProgressOption.lastMonth:
          return _getLastMonthDuration(previousSessions);
        case ChartProgressOption.lastYear:
          return _getLastYearDuration(previousSessions);
      }

    case ChartWorkoutValueOption.volume:
      switch (chart.chartOptions.progressOption) {
        case ChartProgressOption.lastWeek:
          return _getLastWeekVolume(previousSessions);
        case ChartProgressOption.lastMonth:
          return _getLastMonthVolume(previousSessions);
        case ChartProgressOption.lastYear:
          return _getLastYearVolume(previousSessions);
      }
  }
}

// ========================================= A M O U N T  ========================================= //

List<FlSpot> _getLastWeekAmount(List<WorkoutSession> previousSessions) {
  List<FlSpot> chartSpots = [];
  double xAxisPosition = 6;

  for (var date in DateTimeUtil.getLastWeek()) {
    int workoutCount = 0;

    for (WorkoutSession session in previousSessions) {
      if (DateTimeUtil.isSameDay(session.date!, date)) {
        workoutCount++;
      }
    }

    chartSpots.add(FlSpot(xAxisPosition, workoutCount.toDouble()));
    xAxisPosition -= 1;
  }

  return chartSpots;
}

List<FlSpot> _getLastMonthAmount(List<WorkoutSession> previousSessions) {
  List<FlSpot> chartSpots = [];

  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime startDate = now.subtract(const Duration(days: 34));

  for (int i = 4; i > 0; i--) {
    DateTime weekStart = startDate.add(Duration(days: i * 7));
    DateTime weekEnd = weekStart.add(const Duration(days: 6));

    int workoutCount = 0;
    for (WorkoutSession session in previousSessions) {
      DateTime workoutDate = session.date!;

      if ((workoutDate.isAfter(weekStart) || workoutDate.isAtSameMomentAs(weekStart)) &&
          (workoutDate.isBefore(weekEnd) || workoutDate.isAtSameMomentAs(weekEnd))) {
        workoutCount++;
      }
    }

    chartSpots.add(FlSpot(i.toDouble(), workoutCount.toDouble()));
  }

  return chartSpots;
}

List<FlSpot> _getLastYearAmount(List<WorkoutSession> previousSessions) {
  List<FlSpot> chartSpots = [];
  DateTime now = DateTime.now();

  for (int i = 12; i > 0; i--) {
    DateTime monthStart = DateTime(now.year, now.month - i, 1);

    int daysInMonth = DateTime(now.year, now.month - i + 1, 0).day;
    DateTime monthEnd = DateTime(now.year, now.month - i, daysInMonth);

    int workoutCount = 0;
    for (WorkoutSession session in previousSessions) {
      DateTime workoutDate = session.date!;

      if (workoutDate.isAfter(monthStart) && workoutDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
        workoutCount++;
      }
    }

    chartSpots.add(FlSpot((13 - i).toDouble(), workoutCount.toDouble()));
  }

  return chartSpots;
}

// ========================================= D U R A T I O N  ========================================= //

List<FlSpot> _getLastWeekDuration(List<WorkoutSession> previousSessions) {
  List<FlSpot> chartSpots = [];
  double xAxisPosition = 6;

  for (var date in DateTimeUtil.getLastWeek()) {
    num totalDuration = 0;

    for (WorkoutSession session in previousSessions) {
      if (DateTimeUtil.isSameDay(session.date!, date)) {
        totalDuration += session.durationInSeconds!;
      }
    }

    chartSpots.add(FlSpot(xAxisPosition, totalDuration / 3600));
    xAxisPosition -= 1;
  }

  return chartSpots;
}

List<FlSpot> _getLastMonthDuration(List<WorkoutSession> previousSessions) {
  List<FlSpot> chartSpots = [];

  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime startDate = now.subtract(const Duration(days: 34));

  for (int i = 4; i > 0; i--) {
    DateTime weekStart = startDate.add(Duration(days: i * 7));
    DateTime weekEnd = weekStart.add(const Duration(days: 6));

    num totalDuration = 0;
    for (WorkoutSession session in previousSessions) {
      DateTime workoutDate = session.date!;

      if ((workoutDate.isAfter(weekStart) || workoutDate.isAtSameMomentAs(weekStart)) &&
          (workoutDate.isBefore(weekEnd) || workoutDate.isAtSameMomentAs(weekEnd))) {
        totalDuration += session.durationInSeconds!;
      }
    }

    chartSpots.add(FlSpot(i.toDouble(), totalDuration / 3600));
  }

  return chartSpots;
}

List<FlSpot> _getLastYearDuration(List<WorkoutSession> previousSessions) {
  List<FlSpot> chartSpots = [];
  DateTime now = DateTime.now();

  for (int i = 12; i > 0; i--) {
    DateTime monthStart = DateTime(now.year, now.month - i, 1);

    int daysInMonth = DateTime(now.year, now.month - i + 1, 0).day;
    DateTime monthEnd = DateTime(now.year, now.month - i, daysInMonth);

    num totalDuration = 0;
    for (WorkoutSession session in previousSessions) {
      DateTime workoutDate = session.date!;

      if (workoutDate.isAfter(monthStart) && workoutDate.isBefore(monthEnd.add(const Duration(days: 1)))) {
        totalDuration += session.durationInSeconds!;
      }
    }

    chartSpots.add(FlSpot((13 - i).toDouble(), totalDuration / 3600));
  }

  return chartSpots;
}

// ========================================== V O L U M E  ========================================== //

List<FlSpot> _getLastWeekVolume(List<WorkoutSession> previousSessions) {
  List<FlSpot> chartSpots = [];
  double xAxisPosition = 0;

  for (var date in DateTimeUtil.getLastWeek()) {
    num totalVolume = 0;

    for (WorkoutSession session in previousSessions) {
      if (DateTimeUtil.isSameDay(session.date!, date)) {
        for (Exercise exercise in session.exercises) {
          if (exercise.type == ExerciseType.repetitions) {
            for (var set in exercise.workoutSets) {
              totalVolume += set.repetitions! * set.weight!;
            }
          }
        }
      }
    }

    chartSpots.add(FlSpot(xAxisPosition, totalVolume.toDouble()));
    xAxisPosition -= 1;
  }

  return chartSpots;
}

List<FlSpot> _getLastMonthVolume(List<WorkoutSession> previousSessions) {
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
            for (var set in exercise.workoutSets) {
              totalVolume += set.repetitions! * set.weight!;
            }
          }
        }
      }
    }

    chartSpots.add(FlSpot(i.toDouble(), totalVolume.toDouble()));
  }

  return chartSpots;
}

List<FlSpot> _getLastYearVolume(List<WorkoutSession> previousSessions) {
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
            for (var set in exercise.workoutSets) {
              totalVolume += set.repetitions! * set.weight!;
            }
          }
        }
      }
    }

    chartSpots.add(FlSpot((13 - i).toDouble(), totalVolume.toDouble()));
  }

  return chartSpots;
}
