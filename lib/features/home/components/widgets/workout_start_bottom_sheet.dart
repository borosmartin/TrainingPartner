import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/exercises/models/workout_set.dart';
import 'package:training_partner/features/workout/components/pages/workout_page.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutStartBottomSheet extends StatefulWidget {
  final WorkoutSession session;
  final List<WorkoutSession> previousSessions;
  final String workoutPlanName;
  final List<Movement> movements;

  const WorkoutStartBottomSheet({
    super.key,
    required this.session,
    required this.previousSessions,
    required this.workoutPlanName,
    required this.movements,
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
          const Card(
            elevation: 0,
            color: Colors.black26,
            child: SizedBox(height: 5, width: 80),
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
                      Text(workoutSession.name, style: boldLargeBlack),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Iconsax.note_215, color: Colors.black38),
                      const SizedBox(width: 8),
                      Text(widget.workoutPlanName, style: normalGrey),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Iconsax.close_circle5, size: 30, color: Colors.black38),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomTitleButton(
            icon: Iconsax.play5,
            label: 'Start workout',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => WorkoutPage(
                    session: workoutSession,
                    previousSession: _getPreviousSession(widget.previousSessions, workoutSession),
                    movements: widget.movements,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          _getExerciseCards(),
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
                ? '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}'
                    '  -  ${exercise.workoutSets.first.distance} km'
                : ''
        : '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}'
            '  -  ${exercise.workoutSets.length} x ${_getExerciseRepCount(exercise)} reps';

    return Container(
      decoration: isFirst && isLast
          ? const BoxDecoration(color: Colors.white, borderRadius: defaultBorderRadius)
          : isFirst
              ? const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ))
              : isLast
                  ? const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ))
                  : const BoxDecoration(
                      color: Colors.white,
                    ),
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
                  CachedNetworkImage(
                    imageUrl: widget.movements.firstWhere((movement) => movement.id == exercise.movement.id).gifUrl,
                    height: 80,
                    width: 80,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                        borderRadius: defaultBorderRadius,
                      ),
                    ),
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: ShimmerContainer(height: 80, width: 80),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
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
                                  Text(exercise.movement.name, style: boldNormalBlack),
                                  Text(subtitle, style: normalGrey),
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
