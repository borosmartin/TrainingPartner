import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_detail_body.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_type_body.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_value_body.dart';
import 'package:training_partner/features/statistics/logic/cubits/chart_builder_cubit.dart';
import 'package:training_partner/features/statistics/logic/states/chart_builder_state.dart';

class ChartCreatorBottomSheet extends StatefulWidget {
  final List<Movement> movements;

  const ChartCreatorBottomSheet({super.key, required this.movements});

  @override
  State<ChartCreatorBottomSheet> createState() => _ChartCreatorBottomSheetState();
}

class _ChartCreatorBottomSheetState extends State<ChartCreatorBottomSheet> {
  ChartBuilderCubit get _cubit => context.read<ChartBuilderCubit>();

  ChartBuilderChartType? selectedType;
  String? selectedMuscle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Card(
            elevation: 0,
            color: Colors.black26,
            child: SizedBox(height: 5, width: 80),
          ),
          _getBodyContent(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // todo icons
  Widget _getBodyContent() {
    return BlocBuilder<ChartBuilderCubit, ChartBuilderState>(builder: (context, state) {
      if (state is ChartBuilderUninitialized) {
        return _getTypePicker();
      } else if (state is ChartBuilderTypeSelected) {
        return _getValuePicker();
      } else if (state is ChartBuilderValueSelected) {
        return _getDetailPicker(state);
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
        const Text("Select the type of information you'd like to visualize on a chart.", style: normalGrey),
        const SizedBox(height: 15),
        ChartCreatorTypeBody(
          onChartTypeSelected: (type) {
            setState(() {
              selectedType = type;
            });
          },
        ),
      ],
    );
  }

  Widget _getValuePicker() {
    String title = '';
    if (selectedType == ChartBuilderChartType.workout) {
      title = 'Workout';
    } else if (selectedType == ChartBuilderChartType.exercise) {
      title = 'Exercise';
    } else if (selectedType == ChartBuilderChartType.muscle) {
      title = 'Muscle';
    }

    // todo
    String subtitle = '';
    if (selectedType == ChartBuilderChartType.workout) {
      subtitle = 'Workout';
    } else if (selectedType == ChartBuilderChartType.exercise) {
      subtitle = 'Exercise';
    } else if (selectedType == ChartBuilderChartType.muscle) {
      subtitle = 'Select which target muscle you want to visualize!';
    }

    return Column(
      children: [
        const SizedBox(height: 15),
        _getBottomSheetHeader(2, title),
        const SizedBox(height: 5),
        Text(subtitle, style: normalGrey),
        const SizedBox(height: 10),
        ChartCreatorValueBody(
          type: selectedType!,
          movements: widget.movements,
          onMuscleSelected: (muscle) {
            setState(() {
              selectedMuscle = muscle;
            });
          },
        ),
      ],
    );
  }

  Widget _getDetailPicker(ChartBuilderValueSelected state) {
    return Column(
      children: [
        const SizedBox(height: 15),
        _getBottomSheetHeader(3, state.muscle!),
        const SizedBox(height: 10),
        ChartCreatorDetailBody(type: selectedType!),
      ],
    );
  }

  Widget _getBottomSheetHeader(int stage, String title) {
    bool isNextStageEnabled = false;
    if (stage == 1 && selectedType != null) {
      isNextStageEnabled = true;
    } else if (stage == 2 && selectedMuscle != null) {
      isNextStageEnabled = true;
    } else if (stage == 3) {
      // todo
      isNextStageEnabled = true;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => onBack(stage),
          child: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back, color: Colors.black38),
        ),
        Text(title, style: boldLargeBlack),
        GestureDetector(
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
      selectedType = null;
      selectedMuscle = null;
      Navigator.pop(context);
    } else if (stage == 2) {
      selectedType = null;
      selectedMuscle = null;
      _cubit.toFirstStage();
    } else if (stage == 3) {
      selectedMuscle = null;
      _cubit.toSecondStage(selectedType!);
    }
  }

  void onForward(int stage) {
    if (stage == 1) {
      _cubit.toSecondStage(selectedType!);
    } else if (stage == 2) {
      _cubit.toThirdStage(muscle: selectedMuscle);
    } else if (stage == 3) {
      // todo
    }
  }
}
