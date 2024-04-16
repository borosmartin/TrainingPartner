import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class ProgressBarChart extends StatefulWidget {
  final WorkoutSession currentSession;
  final WorkoutSession previousSession;

  const ProgressBarChart({super.key, required this.currentSession, required this.previousSession});

  @override
  State<ProgressBarChart> createState() => _ProgressBarChartState();
}

class _ProgressBarChartState extends State<ProgressBarChart> {
  WorkoutSession get currentSession => widget.currentSession;
  WorkoutSession get previousSession => widget.previousSession;

  late List<_BarData> _chartData;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();

    _chartData = _getChartDataFromExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.4,
          child: BarChart(
            swapAnimationCurve: Curves.easeInOutQuint,
            swapAnimationDuration: const Duration(seconds: 1),
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    width: 1.5,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(show: false),
              barGroups: _chartData.asMap().entries.map((element) {
                final index = element.key;
                final data = element.value;
                return generateBarGroup(
                  index,
                  data.color,
                  data.value,
                  data.previousValue,
                );
              }).toList(),
              maxY: _getMaxYValue(),
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Theme.of(context).colorScheme.tertiary,
                  tooltipMargin: 0,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem('', CustomTextStyle.bodySmallTetriary(context), children: [
                      TextSpan(text: _getPreviousText(rod.toY)),
                      TextSpan(text: _getCurrentText(groupIndex)),
                    ]);
                  },
                ),
                touchCallback: (event, response) {
                  if (event.isInterestedForInteractions && response != null && response.spot != null) {
                    setState(() {
                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                    });
                  } else {
                    setState(() {
                      touchedGroupIndex = -1;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _getExerciseIndicatorRow(),
      ],
    );
  }

  Widget _getExerciseIndicatorRow() {
    List<Widget> children = [];

    for (int i = 0; i < currentSession.exercises.length; i++) {
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(
                height: 15,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: chartColors[i % chartColors.length],
                ),
              ),
              const SizedBox(width: 10),
              Text('${currentSession.exercises[i].movement.name}:', style: CustomTextStyle.bodySmallPrimary(context)),
              const Spacer(),
              _getPrecentWidget(currentSession.exercises[i], previousSession.exercises[i]),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _getPrecentWidget(Exercise currentExercise, Exercise previousExercise) {
    _getProgressPrecentage(currentExercise, previousExercise);
    int precent = _getProgressPrecentage(currentExercise, previousExercise);
    Icon icon;
    TextStyle precentStyle;

    if (precent == 0) {
      icon = Icon(FontAwesomeIcons.equals, color: Colors.amber.shade700, size: 20);
      precentStyle = CustomTextStyle.getCustomTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.amber.shade700,
      );
    } else if (precent < 0) {
      icon = const Icon(FontAwesomeIcons.circleArrowDown, color: Colors.red, size: 20);
      precentStyle = CustomTextStyle.getCustomTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.red,
      );
    } else {
      icon = const Icon(FontAwesomeIcons.circleArrowUp, color: Colors.green, size: 20);
      precentStyle = CustomTextStyle.getCustomTextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.green,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('$precent %', style: precentStyle),
        const SizedBox(width: 10),
        icon,
      ],
    );
  }

  List<_BarData> _getChartDataFromExercises() {
    final dataList = <_BarData>[];

    for (int i = 0; i < currentSession.exercises.length; i++) {
      dataList.add(_BarData(
        color: chartColors[i % chartColors.length],
        value: _getAvarageValue(currentSession.exercises[i]),
        previousValue: _getAvarageValue(previousSession.exercises[i]),
      ));
    }

    return dataList;
  }

  BarChartGroupData generateBarGroup(int x, Color color, double value, double previousValue) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: previousValue,
          color: Colors.grey.shade500,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          width: 10,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: value,
            color: Colors.grey.shade300,
          ),
        ),
        BarChartRodData(
          toY: value,
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          width: 10,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: previousValue,
            color: Colors.grey.shade300,
          ),
        ),
      ],
      showingTooltipIndicators: touchedGroupIndex == x ? [0] : [],
    );
  }

  double _getAvarageValue(Exercise exercise) {
    var sum = 0.0;

    switch (exercise.type) {
      case ExerciseType.repetitions:
        for (var set in exercise.workoutSets) {
          if (set.repetitions != null && set.weight != null) {
            sum += set.repetitions! * set.weight!;
          }
        }
        break;

      case ExerciseType.duration:
        for (var set in exercise.workoutSets) {
          if (set.duration != null) {
            sum += set.duration!;
          }
        }
        break;

      case ExerciseType.distance:
        for (var set in exercise.workoutSets) {
          if (set.distance != null) {
            sum += set.distance!;
          }
        }
        break;
    }

    return sum / exercise.workoutSets.length;
  }

  int _getProgressPrecentage(Exercise currentExercise, Exercise previousExercise) {
    double previousAverage = _getAvarageValue(previousExercise);
    double currentAverage = _getAvarageValue(currentExercise);

    double difference = currentAverage - previousAverage;
    double percentageChange = (difference / previousAverage) * 100;

    return percentageChange.round();
  }

  double _getMaxYValue() {
    double max = 0;

    for (var exercise in currentSession.exercises) {
      if (_getAvarageValue(exercise) > max) {
        max = (_getAvarageValue(exercise)).toDouble();
      }
    }

    for (var exercise in previousSession.exercises) {
      if (_getAvarageValue(exercise) > max) {
        max = (_getAvarageValue(exercise)).toDouble();
      }
    }

    return max;
  }

  String _getPreviousText(double value) {
    String unit = '';
    for (var exercise in previousSession.exercises) {
      if (_getAvarageValue(exercise) == value) {
        if (exercise.type == ExerciseType.repetitions) {
          unit = 'kg';
          return 'Pre: ${TextUtil.numToString(value)} $unit\n';
        } else if (exercise.type == ExerciseType.distance) {
          unit = 'km';
        } else if (exercise.type == ExerciseType.duration) {
          unit = 'min';
        }
      }
    }

    return 'Pre: ${TextUtil.numToString(value)} $unit\n';
  }

  String _getCurrentText(int index) {
    String unit = '';
    for (int i = 0; i < currentSession.exercises.length; i++) {
      if (i == index) {
        if (currentSession.exercises[i].type == ExerciseType.repetitions) {
          unit = 'kg';
        } else if (currentSession.exercises[i].type == ExerciseType.distance) {
          unit = 'km';
        } else if (currentSession.exercises[i].type == ExerciseType.duration) {
          unit = 'min';
        }
      }
    }

    return 'Curr: ${TextUtil.numToString(_getAvarageValue(currentSession.exercises[index]))} $unit';
  }
}

class _BarData {
  final Color color;
  final double value;
  final double previousValue;

  const _BarData({
    required this.color,
    required this.value,
    required this.previousValue,
  });
}
