import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/cached_image.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';

class JournalExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final Exercise? previousExercise;
  final bool isFirst;
  final bool isLast;
  final int index;
  final List<Movement> movements;
  final AppSettings settings;

  const JournalExerciseCard({
    super.key,
    required this.exercise,
    this.previousExercise,
    required this.isFirst,
    required this.isLast,
    required this.index,
    required this.movements,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size.width - 110) / 3;

    return Container(
      decoration: isLast
          ? BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            )
          : BoxDecoration(color: Theme.of(context).cardColor),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(top: isFirst ? 0 : 15, bottom: 15, left: 20, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(exercise.movement.name, style: CustomTextStyle.bodyPrimary(context), overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: previousExercise == null ? MainAxisAlignment.start : MainAxisAlignment.spaceAround,
                children: [
                  CachedImage(
                    imageUrl: movements.firstWhere((movement) => movement.id == exercise.movement.id).gifUrl,
                    height: size,
                    width: size,
                  ),
                  if (previousExercise != null) _getWorkoutSetList(context, isPreviousExercise: true),
                  _getWorkoutSetList(context, isPreviousExercise: false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWorkoutSetList(BuildContext context, {bool isPreviousExercise = false}) {
    var width = (MediaQuery.of(context).size.width - 100) / 3;
    Exercise widgetExercise = isPreviousExercise ? previousExercise! : exercise;
    Color cardColor = isPreviousExercise ? Theme.of(context).colorScheme.secondary : chartColors[index % chartColors.length];
    TextStyle textColor = isPreviousExercise ? CustomTextStyle.bodySmallTetriary(context) : CustomTextStyle.bodySmallTetriary(context);

    Widget child = Container();

    List<Widget> sets = [];
    List<Widget> reps = [];

    switch (widgetExercise.type) {
      case ExerciseType.repetitions:
        for (var set in widgetExercise.workoutSets) {
          sets.add(Text(TextUtil.numToString(set.repetitions!), style: textColor));
          reps.add(
            Text(
              TextUtil.getWeightStringWithUnit(weight: set.weight!, setUnit: set.weightUnit!, settingsUnit: settings.weightUnit),
              style: textColor,
            ),
          );
        }

        child = SizedBox(
          height: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: sets,
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  sets.length,
                  (index) => Text('x', style: textColor),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: reps,
              ),
            ],
          ),
        );
        break;

      case ExerciseType.distance:
        var set = widgetExercise.workoutSets.first;
        child = SizedBox(
          height: width,
          width: width,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                  TextUtil.getDistanceStringWithUnit(
                    distance: set.distance!,
                    setUnit: set.distanceUnit!,
                    settingsUnit: settings.distanceUnit,
                  ),
                  style: textColor),
            ),
          ),
        );
        break;

      case ExerciseType.duration:
        child = SizedBox(
          height: width,
          width: width,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text('${TextUtil.numToString(widgetExercise.workoutSets.first.duration!)} min', style: textColor),
            ),
          ),
        );
        break;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Card(
          elevation: 0,
          shape: defaultCornerShape,
          margin: EdgeInsets.zero,
          color: cardColor,
          child: child,
        ),
      ),
    );
  }
}
