import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/cached_image.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_detail_page.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/workout_editor/components/widgets/editor_wheel_dialog.dart';

class EditorExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final List<Movement> movements;
  final bool isFirst;
  final bool isLast;
  final Function(num, num) onValuesChange;
  final VoidCallback onRemoveExercise;
  final VoidCallback onChangeType;
  final AppSettings settings;

  const EditorExerciseCard({
    super.key,
    required this.exercise,
    required this.movements,
    required this.onValuesChange,
    required this.isFirst,
    required this.isLast,
    required this.onRemoveExercise,
    required this.onChangeType,
    required this.settings,
  });

  @override
  State<EditorExerciseCard> createState() => _EditorExerciseCardState();
}

class _EditorExerciseCardState extends State<EditorExerciseCard> {
  Exercise get exercise => widget.exercise;

  late TextEditingController firstController;
  late TextEditingController secondController;

  @override
  void initState() {
    super.initState();

    firstController = TextEditingController();
    secondController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isFirst && widget.isLast
          ? BoxDecoration(color: Theme.of(context).cardColor, borderRadius: defaultBorderRadius)
          : widget.isFirst
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ))
              : widget.isLast
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ))
                  : BoxDecoration(color: Theme.of(context).cardColor),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedImage(
                    imageUrl: widget.movements.firstWhere((movement) => movement.id == exercise.movement.id).gifUrl,
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(exercise.movement.name, style: CustomTextStyle.subtitlePrimary(context)),
                                  Text(TextUtil.firstLetterToUpperCase(exercise.movement.equipment), style: CustomTextStyle.bodySecondary(context)),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                            _getExerciseOptions(),
                          ],
                        ),
                        const SizedBox(height: 5),
                        _getAmountSetterWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAmountSetterWidget() {
    List<Widget> children = [];

    bool isLightMode = Theme.of(context).brightness == Brightness.light;
    TextStyle style = isLightMode
        ? CustomTextStyle.getCustomTextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black26)
        : CustomTextStyle.bodySmallTetriary(context);

    switch (exercise.type) {
      case ExerciseType.repetitions:
        children = [
          Expanded(child: Center(child: Text(_getSetNumString(), style: style))),
          const VerticalDivider(width: 0, thickness: 2, color: Colors.black26, indent: 2, endIndent: 2),
          Expanded(child: Center(child: Text(_getRepNumString(), style: style))),
        ];
        break;

      case ExerciseType.distance:
        String unit = exercise.workoutSets.first.distanceUnit == DistanceUnit.km ? 'km' : 'miles';

        children = [
          Expanded(
            child: Center(
              child: Text(
                exercise.workoutSets.isNotEmpty && exercise.workoutSets.first.distance != null && exercise.workoutSets.first.distance != 0
                    ? '${exercise.workoutSets.first.distance} $unit'
                    : 'Distance',
                style: style,
              ),
            ),
          ),
        ];
        break;

      case ExerciseType.duration:
        children = [
          Expanded(
            child: Center(
              child: Text(
                exercise.workoutSets.isNotEmpty && exercise.workoutSets.first.duration != null && exercise.workoutSets.first.distance != 0
                    ? '${exercise.workoutSets.first.duration} min'
                    : 'Duration',
                style: style,
              ),
            ),
          ),
        ];
        break;
    }

    Color cardColor = isLightMode ? Colors.grey.shade200 : Colors.grey.shade800;
    return Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      color: cardColor,
      child: InkWell(
        borderRadius: defaultBorderRadius,
        onTap: () => _showWheelNumberDialog(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  void _showWheelNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditorWheelDialog(
          firstWheelValue: _getFirstWheelValue(),
          secondWheelValue: _getSecondWheelValue(),
          exerciseType: exercise.type,
          onValuesChange: widget.onValuesChange,
          settings: widget.settings,
        );
      },
    );
  }

  num? _getFirstWheelValue() {
    if (exercise.workoutSets.isNotEmpty) {
      switch (exercise.type) {
        case ExerciseType.repetitions:
          return exercise.workoutSets.length;

        case ExerciseType.distance:
          return exercise.workoutSets.first.distance;

        case ExerciseType.duration:
          return exercise.workoutSets.first.duration;
      }
    }
    return null;
  }

  num? _getSecondWheelValue() {
    if (exercise.type == ExerciseType.repetitions && exercise.workoutSets.isNotEmpty) {
      return exercise.workoutSets.first.repetitions;
    } else {
      return null;
    }
  }

  String _getSetNumString() {
    if (exercise.workoutSets.isNotEmpty) {
      if (exercise.workoutSets.length == 1) {
        return '${exercise.workoutSets.length}  Set';
      } else {
        return '${exercise.workoutSets.length}  Sets';
      }
    } else {
      return 'Sets';
    }
  }

  String _getRepNumString() {
    if (exercise.workoutSets.isNotEmpty &&
        exercise.workoutSets.firstOrNull != null &&
        exercise.workoutSets.first.repetitions != null &&
        exercise.workoutSets.first.repetitions != 0) {
      if (exercise.workoutSets.first.repetitions == 1) {
        return '${exercise.workoutSets.first.repetitions}  Rep';
      } else {
        return '${exercise.workoutSets.first.repetitions}  Reps';
      }
    } else {
      return 'Reps';
    }
  }

  Widget _getExerciseOptions() {
    return QudsPopupButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      items: [
        QudsPopupMenuItem(
          leading: const Icon(Icons.edit),
          title: Text('Change type', style: CustomTextStyle.bodyPrimary(context)),
          onPressed: () => widget.onChangeType(),
        ),
        QudsPopupMenuItem(
          leading: const Icon(FontAwesomeIcons.circleInfo),
          title: Text('About exercise', style: CustomTextStyle.bodyTetriary(context)),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExerciseDetailPage(movement: exercise.movement),
            ),
          ),
        ),
        QudsPopupMenuItem(
          leading: const Icon(PhosphorIconsBold.trash, color: Colors.red),
          title: Text(
            'Remove exercise',
            style: CustomTextStyle.getCustomTextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
          onPressed: () {
            widget.onRemoveExercise();
            setState(() {});
          },
        ),
      ],
      child: Icon(
        Icons.more_vert_rounded,
        size: 25,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();

    super.dispose();
  }
}
