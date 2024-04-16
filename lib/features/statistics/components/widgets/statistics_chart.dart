import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/statistics/logic/cubits/statistics_cubit.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
import 'package:training_partner/features/statistics/models/chart_min_max_values.dart';
import 'package:training_partner/features/statistics/models/chart_options.dart';
import 'package:training_partner/features/statistics/models/exericse_muscle_chart.dart';
import 'package:training_partner/features/statistics/models/workout_chart.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class StatisticsChart extends StatefulWidget {
  final Chart chart;
  final int index;
  final List<WorkoutSession> previousSessions;
  final List<Movement> movements;
  final AppSettings settings;

  const StatisticsChart({
    super.key,
    required this.chart,
    required this.previousSessions,
    required this.movements,
    required this.index,
    required this.settings,
  });

  @override
  State<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: defaultCornerShape,
          color: Theme.of(context).cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getChartHeader(context),
              _getChart(context),
            ],
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _getChartHeader(BuildContext context) {
    late Widget icon;

    if (widget.chart.type == ChartBuilderChartType.workout) {
      icon = const Icon(PhosphorIconsFill.barbell, color: Colors.white);
    } else if (widget.chart.type == ChartBuilderChartType.muscle) {
      icon = const Icon(PhosphorIconsBold.target, color: Colors.white);
    } else if (widget.chart.type == ChartBuilderChartType.exercise) {
      icon = const Icon(FontAwesomeIcons.personRunning, color: Colors.white);
    }

    String title = '';
    String subtitle = '';
    String valueOption = '';
    String calculationOption = '';

    if (widget.chart.type == ChartBuilderChartType.workout) {
      title = 'Workout';
      switch (widget.chart.chartOptions.workoutValueOption) {
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
    } else if (widget.chart.type == ChartBuilderChartType.exercise) {
      String exercise = widget.movements.firstWhere((element) => element.id == widget.chart.exerciseId).name;

      title = 'Exercise';
      subtitle = TextUtil.firstLetterToUpperCase(exercise);
      switch (widget.chart.chartOptions.muscleExerciseValueOption) {
        case ChartMuscleExerciseValueOption.repetitions:
          valueOption = ' (Repetitions)';
          break;
        case ChartMuscleExerciseValueOption.volume:
          valueOption = ' (Volume)';
          break;
        case ChartMuscleExerciseValueOption.weight:
          valueOption = ' (Weight)';
      }
    } else if (widget.chart.type == ChartBuilderChartType.muscle) {
      String muscle = widget.movements.firstWhere((element) => element.target.toLowerCase() == widget.chart.muscleTarget!.toLowerCase()).target;

      title = 'Muscle';
      subtitle = TextUtil.firstLetterToUpperCase(muscle);
      switch (widget.chart.chartOptions.muscleExerciseValueOption) {
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

    if (widget.chart.chartOptions.calculationOption == ChartCalculationOption.average) {
      calculationOption = 'Average';
    } else {
      calculationOption = 'Best set';
    }

    return Material(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      color: chartColors[widget.index % chartColors.length],
      child: InkWell(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        onTap: () => context.read<StatisticsCubit>().deleteChart(widget.chart),
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
                        Text(title, style: CustomTextStyle.subtitleTetriary(context), overflow: TextOverflow.ellipsis),
                        const SizedBox(width: 2),
                        Text(valueOption, style: CustomTextStyle.bodySmallTetriary(context)),
                        const Spacer(),
                        Text(widget.chart.chartOptions.progressOptionString, style: CustomTextStyle.bodyTetriary(context)),
                      ],
                    ),
                    if (subtitle.isNotEmpty)
                      Row(
                        children: [
                          Text(subtitle, style: CustomTextStyle.bodySmallTetriary(context), overflow: TextOverflow.ellipsis),
                          const Spacer(),
                          if (widget.chart.type != ChartBuilderChartType.workout &&
                              widget.chart.chartOptions.muscleExerciseValueOption != ChartMuscleExerciseValueOption.volume)
                            Text(calculationOption, style: CustomTextStyle.bodySmallTetriary(context)),
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
    late TextStyle style;

    if (Theme.of(context).brightness == Brightness.dark) {
      style = CustomTextStyle.getCustomTextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);
    } else {
      style = CustomTextStyle.getCustomTextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600);
    }

    switch (widget.chart.chartOptions.progressOption) {
      case ChartProgressOption.lastWeek:
        int currentWeekday = now.weekday;
        int currentDayIndex = (currentWeekday + 7) % 7;

        int dayIndex = (currentDayIndex + value.toInt()) % 7;

        switch (dayIndex) {
          case 1:
            bottomTitle = Text('Mon', style: style);
            break;
          case 2:
            bottomTitle = Text('Tue', style: style);
            break;
          case 3:
            bottomTitle = Text('Wed', style: style);
            break;
          case 4:
            bottomTitle = Text('Thu', style: style);
            break;
          case 5:
            bottomTitle = Text('Fri', style: style);
            break;
          case 6:
            bottomTitle = Text('Sat', style: style);
            break;
          case 0:
            bottomTitle = Text('Sun', style: style);
            break;
        }

      case ChartProgressOption.lastMonth:
        switch (value.toInt()) {
          case 1:
            bottomTitle = Text('Week 1', style: style);
            break;
          case 2:
            bottomTitle = Text('Week 2', style: style);
            break;
          case 3:
            bottomTitle = Text('Week 3', style: style);
            break;
          case 4:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Text('Week 4', style: CustomTextStyle.bodySmallTetriary(context)),
            );
            break;
        }

      case ChartProgressOption.lastYear:
        int currentMonthIndex = now.month;
        int targetMonthIndex = (currentMonthIndex + value.toInt() - 2) % 12 + 1;

        switch (targetMonthIndex) {
          case 1:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Jan', style: style),
            );
            break;
          case 2:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Feb', style: style),
            );
            break;
          case 3:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Mar', style: style),
            );
            break;
          case 4:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Apr', style: style),
            );
            break;
          case 5:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('May', style: style),
            );
            break;
          case 6:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Jun', style: style),
            );
            break;
          case 7:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Jul', style: style),
            );
            break;
          case 8:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Aug', style: style),
            );
            break;
          case 9:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Sep', style: style),
            );
            break;
          case 10:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Oct', style: style),
            );
            break;
          case 11:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Nov', style: style),
            );
            break;
          case 12:
            bottomTitle = Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('Dec', style: style),
            );
            break;
        }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: widget.chart.chartOptions.progressOption == ChartProgressOption.lastYear ? 70 : 0,
      child: bottomTitle,
    );
  }

  Widget _getChartYAxisValues(double value, TitleMeta meta) {
    late TextStyle style;

    if (Theme.of(context).brightness == Brightness.dark) {
      style = CustomTextStyle.getCustomTextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600);
    } else {
      style = CustomTextStyle.getCustomTextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600);
    }

    if (widget.chart.type == ChartBuilderChartType.workout) {
      return getWorkoutChartYAxisValues(widget.chart, value, widget.settings.weightUnit, style);
    } else {
      return getExerciseMuscleChartYAxisValues(widget.chart, value, widget.settings.weightUnit, style);
    }
  }

  Widget _getChart(BuildContext context) {
    ChartMinMaxValues minMaxValues = _getChartMinMaxValues(widget.chart, widget.previousSessions);

    Color originalColor = chartColors[widget.index % chartColors.length];
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
                return touchedSpots.map((LineBarSpot spot) => _getChartTooltips(context, widget.chart, spot)).toList();
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
    Color chartColor = chartColors[widget.index % chartColors.length];

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
    if (widget.chart.type == ChartBuilderChartType.workout) {
      return getWorkoutChartSpots(widget.chart, widget.previousSessions);
    } else {
      return getExerciseMuscleChartSpots(widget.chart, widget.previousSessions);
    }
  }

  LineTooltipItem _getChartTooltips(BuildContext context, Chart chart, LineBarSpot spot) {
    if (chart.type == ChartBuilderChartType.workout) {
      return getWorkoutChartTooltip(context, chart, spot, widget.settings.weightUnit);
    } else {
      return getExerciseMuscleChartTooltip(context, chart, spot, widget.settings.weightUnit);
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
