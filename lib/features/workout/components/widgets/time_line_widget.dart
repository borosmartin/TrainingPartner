import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class TimeLineWidget extends StatelessWidget {
  final WorkoutSession session;
  final int currentExerciseIndex;
  final Function(int) onExerciseClick;

  const TimeLineWidget({
    super.key,
    required this.session,
    required this.currentExerciseIndex,
    required this.onExerciseClick,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    for (int i = 0; i < session.exercises.length; i++) {
      list.add(_getTimeLineNode(context, i, session.exercises[i]));

      if (i < session.exercises.length - 1) {
        final Color lineColor = (i < currentExerciseIndex) ? accentColor : Theme.of(context).colorScheme.secondary;

        list.add(Expanded(child: Container(height: 2.0, color: lineColor)));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: list),
    );
  }

  Widget _getTimeLineNode(BuildContext context, int index, Exercise exercise) {
    final Color color = index <= currentExerciseIndex ? accentColor : Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: () => onExerciseClick(index),
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(100)),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Center(
            child: Text("${index + 1}", style: CustomTextStyle.bodyTetriary(context)),
          ),
        ),
      ),
    );
  }
}
