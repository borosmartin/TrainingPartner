import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/statistics/logic/cubits/statistics_cubit.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
import 'package:training_partner/features/statistics/models/chart_min_max_values.dart';
import 'package:training_partner/features/statistics/models/chart_options.dart';
import 'package:training_partner/features/statistics/models/exericse_muscle_chart.dart';
import 'package:training_partner/features/statistics/models/workout_chart.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class StatisticsChart extends StatelessWidget {
  final Chart chart;
  final int index;
  final List<WorkoutSession> previousSessions;
  final List<Movement> movements;

  const StatisticsChart({
    super.key,
    required this.chart,
    required this.previousSessions,
    required this.movements,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: defaultCornerShape,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getChartHeader(context),
              _getChart(),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _getChartHeader(BuildContext context) {
    var icon = chart.type == ChartBuilderChartType.workout
        ? const Icon(Iconsax.note_215, color: Colors.white)
        : chart.type == ChartBuilderChartType.muscle
            ? const Padding(
                padding: EdgeInsets.only(right: 5),
                child: Icon(FontAwesomeIcons.dumbbell, size: 19, color: Colors.white),
              )
            : chart.type == ChartBuilderChartType.exercise
                ? const Icon(FontAwesomeIcons.personRunning, color: Colors.white)
                : const Icon(FontAwesomeIcons.dumbbell, color: Colors.white);

    String title = '';
    String subtitle = '';
    String valueOption = '';
    String calculationOption = '';

    if (chart.type == ChartBuilderChartType.workout) {
      title = 'Workout';
      switch (chart.chartOptions.workoutValueOption) {
        case ChartWorkoutValueOption.amount:
          valueOption = ' (Amount)';
          break;
        case ChartWorkoutValueOption.duration:
          valueOption = ' (Duration)';
          break;
        case ChartWorkoutValueOption.volume:
          valueOption = ' (Volume)';
          break;
      }
    } else if (chart.type == ChartBuilderChartType.exercise) {
      String exercise = movements.firstWhere((element) => element.id == chart.exerciseId).name;

      title = 'Exercise';
      subtitle = TextUtil.firstLetterToUpperCase(exercise);
      switch (chart.chartOptions.muscleExerciseValueOption) {
        case ChartMuscleExerciseValueOption.repetitions:
          valueOption = ' (Repetitions)';
          break;
        case ChartMuscleExerciseValueOption.volume:
          valueOption = ' (Volume)';
          break;
        case ChartMuscleExerciseValueOption.weight:
          valueOption = ' (Weight)';
      }
    } else if (chart.type == ChartBuilderChartType.muscle) {
      String muscle = movements.firstWhere((element) => element.target.toLowerCase() == chart.muscleTarget!.toLowerCase()).target;

      title = 'Muscle';
      subtitle = TextUtil.firstLetterToUpperCase(muscle);
      switch (chart.chartOptions.muscleExerciseValueOption) {
        case ChartMuscleExerciseValueOption.repetitions:
          valueOption = ' (Repetitions)';
          break;
        case ChartMuscleExerciseValueOption.volume:
          valueOption = ' (Volume)';
          break;
        case ChartMuscleExerciseValueOption.weight:
          valueOption = ' (Weight)';
      }
    }

    if (chart.chartOptions.calculationOption == ChartCalculationOption.average) {
      calculationOption = 'Average';
    } else {
      calculationOption = 'Best set';
    }

    return Material(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      color: chartColors[index % chartColors.length],
      child: InkWell(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        onTap: () => context.read<StatisticsCubit>().deleteChart(chart),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(title, style: boldNormalWhite, overflow: TextOverflow.ellipsis),
                        const SizedBox(width: 2),
                        Text(valueOption, style: smallWhite),
                        const Spacer(),
                        Text(chart.chartOptions.progressOptionString, style: normalWhite),
                      ],
                    ),
                    Row(
                      children: [
                        Text(subtitle, style: smallWhite, overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        if (chart.type != ChartBuilderChartType.workout &&
                            chart.chartOptions.muscleExerciseValueOption != ChartMuscleExerciseValueOption.volume)
                          Text(calculationOption, style: smallWhite),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getChartXAxisValues(double value, TitleMeta meta) {
    Widget bottomTitle = const Text('');
    DateTime now = DateTime.now();

    switch (chart.chartOptions.progressOption) {
      case ChartProgressOption.lastWeek:
        int currentWeekday = now.weekday;
        int currentDayIndex = (currentWeekday + 7) % 7;

        int dayIndex = (currentDayIndex + value.toInt()) % 7;

        switch (dayIndex) {
          case 1:
            bottomTitle = const Text('Mon', style: smallGrey);
            break;
          case 2:
            bottomTitle = const Text('Tue', style: smallGrey);
            break;
          case 3:
            bottomTitle = const Text('Wed', style: smallGrey);
            break;
          case 4:
            bottomTitle = const Text('Thu', style: smallGrey);
            break;
          case 5:
            bottomTitle = const Text('Fri', style: smallGrey);
            break;
          case 6:
            bottomTitle = const Text('Sat', style: smallGrey);
            break;
          case 0:
            bottomTitle = const Text('Sun', style: smallGrey);
            break;
        }

      case ChartProgressOption.lastMonth:
        switch (value.toInt()) {
          case 1:
            bottomTitle = const Text('Week 1', style: smallGrey);
            break;
          case 2:
            bottomTitle = const Text('Week 2', style: smallGrey);
            break;
          case 3:
            bottomTitle = const Text('Week 3', style: smallGrey);
            break;
          case 4:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(right: 25),
              child: Text('Week 4', style: smallGrey),
            );
            break;
        }

      case ChartProgressOption.lastYear:
        int currentMonthIndex = now.month;
        int targetMonthIndex = (currentMonthIndex + value.toInt() - 2) % 12 + 1;

        switch (targetMonthIndex) {
          case 1:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Jan', style: smallGrey),
            );
            break;
          case 2:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Feb', style: smallGrey),
            );
            break;
          case 3:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Mar', style: smallGrey),
            );
            break;
          case 4:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Apr', style: smallGrey),
            );
            break;
          case 5:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('May', style: smallGrey),
            );
            break;
          case 6:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Jun', style: smallGrey),
            );
            break;
          case 7:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Jul', style: smallGrey),
            );
            break;
          case 8:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Aug', style: smallGrey),
            );
            break;
          case 9:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Sep', style: smallGrey),
            );
            break;
          case 10:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Oct', style: smallGrey),
            );
            break;
          case 11:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Nov', style: smallGrey),
            );
            break;
          case 12:
            bottomTitle = const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Dec', style: smallGrey),
            );
            break;
        }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: chart.chartOptions.progressOption == ChartProgressOption.lastYear ? 70 : 0,
      child: bottomTitle,
    );
  }

  Widget _getChartYAxisValues(double value, TitleMeta meta) {
    if (chart.type == ChartBuilderChartType.workout) {
      return getWorkoutChartYAxisValues(chart, value);
    } else {
      return getExerciseMuscleChartYAxisValues(chart, value);
    }
  }

  Widget _getChart() {
    ChartMinMaxValues minMaxValues = _getChartMinMaxValues(chart, previousSessions);

    Color originalColor = chartColors[index % chartColors.length];
    Color lighterColor = Color.fromRGBO(originalColor.red + 15, originalColor.green + 15, originalColor.blue + 15, 1.0);
    Color darkerColor = Color.fromRGBO(originalColor.red - 30, originalColor.green - 30, originalColor.blue - 30, 1.0);

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 25, top: 30, bottom: 15),
      child: AspectRatio(
        aspectRatio: 1.70,
        child: LineChart(LineChartData(
          minX: minMaxValues.minX,
          maxX: minMaxValues.maxX,
          minY: minMaxValues.minY,
          maxY: minMaxValues.maxY,
          lineBarsData: [_getBarData()],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: lighterColor,
              tooltipBorder: BorderSide(color: darkerColor, width: 2.5),
              tooltipRoundedRadius: 10,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((LineBarSpot spot) => _getChartTooltips(chart, spot)).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: _getChartXAxisValues,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _getChartYAxisValues,
                reservedSize: 55,
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
        )),
      ),
    );
  }

  LineChartBarData _getBarData() {
    Color chartColor = chartColors[index % chartColors.length];

    List<FlSpot> chartSpots = _getChartSpots();

    return LineChartBarData(
      spots: chartSpots,
      color: chartColor,
      isCurved: false,
      barWidth: 3.5,
      preventCurveOverShooting: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(colors: [chartColor.withOpacity(0.75), chartColor.withOpacity(0.45), chartColor.withOpacity(0.2)]),
      ),
    );
  }

  List<FlSpot> _getChartSpots() {
    if (chart.type == ChartBuilderChartType.workout) {
      return getWorkoutChartSpots(chart, previousSessions);
    } else {
      return getExerciseMuscleChartSpots(chart, previousSessions);
    }
  }

  LineTooltipItem _getChartTooltips(Chart chart, LineBarSpot spot) {
    if (chart.type == ChartBuilderChartType.workout) {
      return getWorkoutChartTooltip(chart, spot);
    } else {
      return getExerciseMuscleChartTooltip(chart, spot);
    }
  }

  ChartMinMaxValues _getChartMinMaxValues(Chart chart, List<WorkoutSession> previousSessions) {
    double minXValue = double.infinity;
    double maxXValue = 0;
    double minYValue = double.infinity;
    double maxYValue = 0;

    List<FlSpot> data = [];

    if (chart.type == ChartBuilderChartType.workout) {
      data = getWorkoutChartSpots(chart, previousSessions);
    } else {
      data = getExerciseMuscleChartSpots(chart, previousSessions);
    }

    for (var i = 0; i < data.length; i++) {
      if (data[i].x < minXValue) {
        minXValue = data[i].x;
      }
      if (data[i].x > maxXValue) {
        maxXValue = data[i].x;
      }
      if (data[i].y < minYValue) {
        minYValue = data[i].y;
      }
      if (data[i].y > maxYValue) {
        maxYValue = data[i].y;
      }
    }

    return ChartMinMaxValues(
      minX: minXValue,
      maxX: maxXValue,
      minY: minYValue,
      maxY: maxYValue,
    );
  }
}
