import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/cached_image.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/exercises/models/workout_set.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/workout/components/pages/workout_page.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutStartBottomSheet extends StatefulWidget {
  final WorkoutSession session;
  final List<WorkoutSession> previousSessions;
  final String workoutPlanName;
  final List<Movement> movements;
  final AppSettings settings;

  const WorkoutStartBottomSheet({
    super.key,
    required this.session,
    required this.previousSessions,
    required this.workoutPlanName,
    required this.movements,
    required this.settings,
  });

  @override
  State<WorkoutStartBottomSheet> createState() => _WorkoutStartBottomSheetState();
}

class _WorkoutStartBottomSheetState extends State<WorkoutStartBottomSheet> {
  WorkoutSession get workoutSession => widget.session;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.secondary,
            child: const SizedBox(height: 5, width: 80),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.flash_15),
                      const SizedBox(width: 8),
                      Text(workoutSession.name, style: CustomTextStyle.titlePrimary(context)),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(PhosphorIconsBold.barbell, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(widget.workoutPlanName, style: CustomTextStyle.bodySecondary(context)),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(PhosphorIconsFill.xCircle, size: 30, color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _getExerciseCards(),
          const SizedBox(height: 15),
          CustomTitleButton(
            icon: PhosphorIconsBold.playCircle,
            label: 'Start workout',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WorkoutPage(
                    session: workoutSession,
                    previousSession: _getPreviousSession(widget.previousSessions, workoutSession),
                    movements: widget.movements,
                    settings: widget.settings,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getExerciseCards() {
    List<Widget> exerciseWidgets = [];

    for (int i = 0; i < workoutSession.exercises.length; i++) {
      exerciseWidgets.add(_getExerciseCard(workoutSession.exercises[i], i));
    }

    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          children: exerciseWidgets,
        ),
      ),
    );
  }

  Widget _getExerciseCard(Exercise exercise, int index) {
    bool isFirst = index == 0;
    bool isLast = index == workoutSession.exercises.length - 1;

    String subtitle = exercise.workoutSets.any((element) => element.repetitions == null)
        ? exercise.workoutSets.first.duration != null
            ? '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}'
                '  -  ${exercise.workoutSets.first.duration} min'
            : exercise.workoutSets.first.distance != null
                ? widget.settings.distanceUnit == DistanceUnit.km
                    ? '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}'
                        '  -  ${exercise.workoutSets.first.distance} km'
                    : '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}'
                        '  -  ${exercise.workoutSets.first.distance} miles'
                : ''
        : '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}'
            '  -  ${exercise.workoutSets.length} x ${_getExerciseRepCount(exercise)} reps';

    return Container(
      decoration: isFirst && isLast
          ? BoxDecoration(color: Theme.of(context).cardColor, borderRadius: defaultBorderRadius)
          : isFirst
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ))
              : isLast
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
                    height: 80,
                    width: 80,
                    imageUrl: widget.movements.firstWhere((movement) => movement.id == exercise.movement.id).gifUrl,
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
                                  Text(subtitle, style: CustomTextStyle.bodySecondary(context)),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  String _getExerciseRepCount(Exercise exercise) {
    num avarageReps = 0;

    for (WorkoutSet set in exercise.workoutSets) {
      if (set.repetitions != null) {
        avarageReps += set.repetitions!;
      }
    }

    return int.parse((avarageReps / exercise.workoutSets.length).toStringAsFixed(0)).toString();
  }

  WorkoutSession? _getPreviousSession(List<WorkoutSession> sessions, WorkoutSession currentSession) {
    WorkoutSession? previousSession;

    for (var session in sessions) {
      if (session.id == currentSession.id) {
        if (previousSession == null || session.date!.isAfter(previousSession.date!)) {
          previousSession = session;
        }
      }
    }

    return previousSession;
  }
}
