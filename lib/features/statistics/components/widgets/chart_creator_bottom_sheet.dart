import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_options_body.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_type_body.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_value_body.dart';
import 'package:training_partner/features/statistics/logic/cubits/chart_builder_cubit.dart';
import 'package:training_partner/features/statistics/logic/cubits/statistics_cubit.dart';
import 'package:training_partner/features/statistics/logic/states/chart_builder_state.dart';
import 'package:training_partner/features/statistics/models/chart.dart';

class ChartCreatorBottomSheet extends StatefulWidget {
  final List<Movement> movements;

  const ChartCreatorBottomSheet({super.key, required this.movements});

  @override
  State<ChartCreatorBottomSheet> createState() => _ChartCreatorBottomSheetState();
}

class _ChartCreatorBottomSheetState extends State<ChartCreatorBottomSheet> {
  ChartBuilderCubit get _cubit => context.read<ChartBuilderCubit>();

  late Chart chart;

  @override
  void initState() {
    super.initState();

    chart = Chart(id: _getRandomId());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.secondary,
              child: const SizedBox(height: 5, width: 80),
            ),
            _getBodyContent(),
          ],
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return BlocBuilder<ChartBuilderCubit, ChartBuilderState>(builder: (context, state) {
      if (state is ChartBuilderUninitialized) {
        return _getTypePicker();
      } else if (state is ChartBuilderTypeSelected) {
        return _getValuePicker();
      } else if (state is ChartBuilderValueSelected) {
        return _getOptionsPicker(state);
      }

      throw UnimplementedError();
    });
  }

  Widget _getTypePicker() {
    return Column(
      children: [
        const SizedBox(height: 15),
        _getBottomSheetHeader(1, 'New chart'),
        const SizedBox(height: 5),
        Text("Select the type of information you'd like to visualize on a chart:", style: CustomTextStyle.bodySecondary(context)),
        const SizedBox(height: 15),
        ChartCreatorTypeBody(
          onChartTypeSelected: (type) {
            setState(() {
              chart.type = type;
            });
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _getValuePicker() {
    String title = '';
    if (chart.type == ChartBuilderChartType.exercise) {
      title = 'Exercise';
    } else if (chart.type == ChartBuilderChartType.muscle) {
      title = 'Muscle';
    }

    String subtitle = '';
    if (chart.type == ChartBuilderChartType.exercise) {
      subtitle = 'Select which exercise you want to visualize:';
    } else if (chart.type == ChartBuilderChartType.muscle) {
      subtitle = 'Select which target muscle you want to visualize:';
    }

    return Column(
      children: [
        const SizedBox(height: 15),
        _getBottomSheetHeader(2, title),
        const SizedBox(height: 5),
        Text(subtitle, style: CustomTextStyle.bodySecondary(context)),
        const SizedBox(height: 10),
        ChartCreatorValueBody(
          type: chart.type!,
          movements: widget.movements,
          onValueSelected: (value) {
            setState(() {
              if (chart.type == ChartBuilderChartType.exercise) {
                chart.exerciseId = value;
              } else if (chart.type == ChartBuilderChartType.muscle) {
                chart.muscleTarget = value;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _getOptionsPicker(ChartBuilderValueSelected state) {
    return Column(
      children: [
        const SizedBox(height: 15),
        _getBottomSheetHeader(3, 'Options'),
        const SizedBox(height: 5),
        Text('Here you can fine tune the options for your chart:', style: CustomTextStyle.bodySecondary(context)),
        const SizedBox(height: 15),
        ChartCreatorOptionsBody(
          type: chart.type!,
          muscle: chart.muscleTarget,
          exerciseId: chart.exerciseId,
          movements: widget.movements,
          onOptionsChanged: (options) {
            setState(() {
              chart.chartOptions = options;
            });
          },
          onExerciseMuscleOnTap: () {
            if (chart.type == ChartBuilderChartType.exercise) {
              chart.exerciseId = null;
              _cubit.toSecondStage();
            } else if (chart.type == ChartBuilderChartType.muscle) {
              chart.muscleTarget = null;
              _cubit.toSecondStage();
            }
          },
          onAddButtonTap: () => context.read<StatisticsCubit>().saveChart(chart),
        ),
      ],
    );
  }

  Widget _getBottomSheetHeader(int stage, String title) {
    bool isNextStageEnabled = false;
    if (stage == 1 && chart.type != null) {
      isNextStageEnabled = true;
    } else if (stage == 2 && (chart.muscleTarget != null || chart.exerciseId != null)) {
      isNextStageEnabled = true;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => onBack(stage),
          child: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.black38),
        ),
        Text(title, style: CustomTextStyle.titlePrimary(context)),
        stage == 3
            ? const Icon(Icons.arrow_forward, color: Colors.transparent)
            : GestureDetector(
                onTap: isNextStageEnabled ? () => onForward(stage) : null,
                child: Icon(
                  Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
                  color: isNextStageEnabled ? Theme.of(context).colorScheme.tertiary : Colors.black38,
                ),
              ),
      ],
    );
  }

  void onBack(int stage) {
    if (stage == 1) {
      Navigator.pop(context);
    } else if (stage == 2) {
      chart.type = null;
      chart.muscleTarget = null;
      chart.exerciseId = null;

      _cubit.toFirstStage();
    } else if (stage == 3) {
      if (chart.type == ChartBuilderChartType.workout) {
        chart.type = null;

        _cubit.toFirstStage();
        return;
      }

      chart.muscleTarget = null;
      chart.exerciseId = null;

      _cubit.toSecondStage();
    }
  }

  void onForward(int stage) {
    if (stage == 1) {
      if (chart.type == ChartBuilderChartType.workout) {
        _cubit.toThirdStage();
        return;
      }

      _cubit.toSecondStage();
    } else if (stage == 2) {
      _cubit.toThirdStage();
    }
  }

  String _getRandomId() {
    List<String> existingIds = [];

    return TextUtil.generateUniqueId(existingIds);
  }
}
