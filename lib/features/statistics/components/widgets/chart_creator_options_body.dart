import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_options_card.dart';
import 'package:training_partner/features/statistics/logic/cubits/chart_builder_cubit.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
import 'package:training_partner/features/statistics/models/chart_options.dart';

class ChartCreatorOptionsBody extends StatefulWidget {
  final ChartBuilderChartType type;
  final String? muscle;
  final String? exerciseId;
  final List<Movement> movements;
  final Function(ChartOptions) onOptionsChanged;
  final Function onExerciseMuscleOnTap;
  final Function onAddButtonTap;

  const ChartCreatorOptionsBody({
    Key? key,
    required this.type,
    this.muscle,
    this.exerciseId,
    required this.movements,
    required this.onOptionsChanged,
    required this.onExerciseMuscleOnTap,
    required this.onAddButtonTap,
  }) : super(key: key);

  @override
  State<ChartCreatorOptionsBody> createState() => _ChartCreatorOptionsBodyState();
}

class _ChartCreatorOptionsBodyState extends State<ChartCreatorOptionsBody> {
  int? selectedIndex;
  late String title;

  ChartOptions chartOptions = const ChartOptions();

  @override
  void initState() {
    super.initState();

    title = widget.muscle ?? '';
  }

  // todo icons
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getOptions(),
        const SizedBox(height: 30),
        CustomTitleButton(
          label: 'Add chart',
          icon: Icons.add,
          onTap: () {
            widget.onAddButtonTap();
            Navigator.of(context).pop();
            context.read<ChartBuilderCubit>().toFirstStage();
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _getOptions() {
    List<Widget> cards = [];

    switch (widget.type) {
      case ChartBuilderChartType.workout:
        cards = _getWorkoutOptions();
        break;

      case ChartBuilderChartType.exercise:
        cards = _getExerciseOptions();
        break;

      case ChartBuilderChartType.muscle:
        cards = _getMuscleOptions();
        break;
    }

    return Column(
      children: cards,
    );
  }

  List<Widget> _getWorkoutOptions() {
    return [
      ChartCreatorOptionsCard(
        title: 'Value',
        value: _getWorkoutValueText(),
        icon: const Icon(Iconsax.element_45, color: Colors.black38),
        options: _getWorkoutValueOptions(),
      ),
      const SizedBox(height: 10),
      ChartCreatorOptionsCard(
        title: 'Progress',
        value: _getProgressText(),
        icon: const Icon(FontAwesomeIcons.arrowTrendUp, color: Colors.black38, size: 20),
        options: _getProgressOptions(),
      ),
    ];
  }

  List<Widget> _getExerciseOptions() {
    return [
      ChartCreatorOptionsCard(
        title: 'Exercise',
        value: widget.movements.firstWhere((movement) => movement.id == widget.exerciseId).name,
        icon: const Icon(FontAwesomeIcons.dumbbell, color: Colors.black38, size: 20),
        options: _getProgressOptions(),
        onTap: widget.onExerciseMuscleOnTap,
      ),
      const SizedBox(height: 10),
      ChartCreatorOptionsCard(
        title: 'Value',
        value: _getExerciseMuscleValueText(),
        icon: const Icon(Iconsax.element_45, color: Colors.black38),
        options: _getExerciseMuscleValueOptions(),
      ),
      if (chartOptions.muscleExerciseValueOption != ChartMuscleExerciseValueOption.volume) const SizedBox(height: 10),
      if (chartOptions.muscleExerciseValueOption != ChartMuscleExerciseValueOption.volume)
        ChartCreatorOptionsCard(
          title: 'Calculation',
          value: _getCalculationText(),
          icon: const Icon(Iconsax.math5, color: Colors.black38),
          options: _getCalculationOptions(),
        ),
      const SizedBox(height: 10),
      ChartCreatorOptionsCard(
        title: 'Progress',
        value: _getProgressText(),
        icon: const Icon(FontAwesomeIcons.arrowTrendUp, color: Colors.black38, size: 20),
        options: _getProgressOptions(),
      ),
    ];
  }

  List<Widget> _getMuscleOptions() {
    return [
      ChartCreatorOptionsCard(
        title: 'Muscle',
        value: title,
        icon: const Icon(Iconsax.weight_15, color: Colors.black38),
        options: _getProgressOptions(),
        onTap: widget.onExerciseMuscleOnTap,
      ),
      const SizedBox(height: 10),
      ChartCreatorOptionsCard(
        title: 'Value',
        value: _getExerciseMuscleValueText(),
        icon: const Icon(Iconsax.element_45, color: Colors.black38),
        options: _getExerciseMuscleValueOptions(),
      ),
      if (chartOptions.muscleExerciseValueOption != ChartMuscleExerciseValueOption.volume) const SizedBox(height: 10),
      if (chartOptions.muscleExerciseValueOption != ChartMuscleExerciseValueOption.volume)
        ChartCreatorOptionsCard(
          title: 'Calculation',
          value: _getCalculationText(),
          icon: const Icon(Iconsax.math5, color: Colors.black38),
          options: _getCalculationOptions(),
        ),
      const SizedBox(height: 10),
      ChartCreatorOptionsCard(
        title: 'Progress',
        value: _getProgressText(),
        icon: const Icon(FontAwesomeIcons.arrowTrendUp, color: Colors.black38, size: 20),
        options: _getProgressOptions(),
      ),
    ];
  }

  List<QudsPopupMenuItem> _getCalculationOptions() {
    List<QudsPopupMenuItem> options = [
      QudsPopupMenuItem(
        title: const Text('Avarage', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(calculationOption: ChartCalculationOption.average);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
      QudsPopupMenuItem(
        title: const Text('Best set', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(calculationOption: ChartCalculationOption.best);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
    ];

    return options;
  }

  List<QudsPopupMenuItem> _getExerciseMuscleValueOptions() {
    List<QudsPopupMenuItem> options = [
      QudsPopupMenuItem(
        title: const Text('Repetitions', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(muscleExerciseValueOption: ChartMuscleExerciseValueOption.repetitions);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
      QudsPopupMenuItem(
        title: const Text('Volume', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(muscleExerciseValueOption: ChartMuscleExerciseValueOption.volume);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
      QudsPopupMenuItem(
        title: const Text('Weight', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(muscleExerciseValueOption: ChartMuscleExerciseValueOption.weight);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
    ];

    return options;
  }

  List<QudsPopupMenuItem> _getWorkoutValueOptions() {
    List<QudsPopupMenuItem> options = [
      QudsPopupMenuItem(
        title: const Text('Amount', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(workoutValueOption: ChartWorkoutValueOption.amount);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
      QudsPopupMenuItem(
        title: const Text('Duration', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(workoutValueOption: ChartWorkoutValueOption.duration);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
      QudsPopupMenuItem(
        title: const Text('Volume', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(workoutValueOption: ChartWorkoutValueOption.volume);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
    ];

    return options;
  }

  List<QudsPopupMenuItem> _getProgressOptions() {
    List<QudsPopupMenuItem> options = [
      QudsPopupMenuItem(
        title: const Text('Last week', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(progressOption: ChartProgressOption.lastWeek);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
      QudsPopupMenuItem(
        title: const Text('Last month', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(progressOption: ChartProgressOption.lastMonth);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
      QudsPopupMenuItem(
        title: const Text('Last year', style: normalBlack),
        onPressed: () {
          setState(() {
            chartOptions = chartOptions.copyWith(progressOption: ChartProgressOption.lastYear);
            widget.onOptionsChanged(chartOptions);
          });
        },
      ),
    ];

    return options;
  }

  String _getCalculationText() {
    switch (chartOptions.calculationOption) {
      case ChartCalculationOption.best:
        return 'Best set';
      case ChartCalculationOption.average:
        return 'Avarage';
    }
  }

  String _getExerciseMuscleValueText() {
    switch (chartOptions.muscleExerciseValueOption) {
      case ChartMuscleExerciseValueOption.repetitions:
        return 'Repetitions';
      case ChartMuscleExerciseValueOption.volume:
        return 'Volume';
      case ChartMuscleExerciseValueOption.weight:
        return 'Weight';
    }
  }

  String _getWorkoutValueText() {
    switch (chartOptions.workoutValueOption) {
      case ChartWorkoutValueOption.amount:
        return 'Amount';
      case ChartWorkoutValueOption.duration:
        return 'Duration';
      case ChartWorkoutValueOption.volume:
        return 'Volume';
    }
  }

  String _getProgressText() {
    switch (chartOptions.progressOption) {
      case ChartProgressOption.lastWeek:
        return 'Last week';
      case ChartProgressOption.lastMonth:
        return 'Last month';
      case ChartProgressOption.lastYear:
        return 'Last year';
    }
  }
}
