import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/features/home/components/widgets/workout_start_bottom_sheet.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';
import 'package:training_partner/generated/assets.dart';

class WorkoutSessionList extends StatelessWidget {
  final WorkoutPlan workoutPlan;

  const WorkoutSessionList({
    super.key,
    required this.workoutPlan,
  });

  List<WorkoutSession> get sessions => workoutPlan.sessions;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: buildSessionRows(context),
        ),
      ),
    );
  }

  List<Widget> buildSessionRows(BuildContext context) {
    List<Widget> sessionRows = [];
    for (int i = 0; i < sessions.length; i++) {
      sessionRows.add(buildSessionRow(context, i, sessions[i]));
    }
    return sessionRows;
  }

  Widget buildSessionRow(BuildContext context, int index, WorkoutSession session) {
    bool isLast = index == sessions.length - 1;
    int setNum = 0;

    for (var set in session.exercises) {
      setNum += set.workoutSets.length;
    }

    return Container(
      height: 75,
      decoration: isLast
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
        child: InkWell(
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : BorderRadius.zero,
          onTap: () => _showWorkoutStartBottomSheet(context, session),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                const SizedBox(width: 5),
                SizedBox(
                  width: 30,
                  child: Center(
                    child: Text((index + 1).toString(), style: boldLargeBlack),
                  ),
                ),
                const SizedBox(width: 5),
                const CustomDivider(isVertical: true),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.name, style: normalBlack),
                    Text('${session.exercises.length} exercise  -  $setNum sets', style: normalGrey),
                  ],
                ),
                const Spacer(),
                _getBodyPartsWidget(session),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBodyPartsWidget(WorkoutSession session) {
    List<String> bodyPartIcons = [];
    List<Widget> bodyParts = [];

    for (var exercise in session.exercises) {
      if (exercise.movement.bodyPart == 'chest' && !bodyPartIcons.contains('chest')) {
        bodyParts.add(_getBodyPartIcon(Assets.assetsImagesChestIcon));
        bodyPartIcons.add('chest'); // Hozzáadjuk az ikont és a listához azonosítóként a testrészt
      }
      if (exercise.movement.bodyPart.contains('arms') && !bodyPartIcons.contains('arms')) {
        bodyParts.add(_getBodyPartIcon(Assets.assetsImagesArmsIcon));
        bodyPartIcons.add('arms');
      }
      if (exercise.movement.bodyPart == 'shoulders' && !bodyPartIcons.contains('shoulders')) {
        bodyParts.add(_getBodyPartIcon(Assets.assetsImagesShoulderIcon));
        bodyPartIcons.add('shoulders');
      }
      if (exercise.movement.bodyPart == 'back' && !bodyPartIcons.contains('back')) {
        bodyParts.add(_getBodyPartIcon(Assets.assetsImagesBackIcon));
        bodyPartIcons.add('back');
      }
      if (exercise.movement.bodyPart == 'waist' && !bodyPartIcons.contains('waist')) {
        bodyParts.add(_getBodyPartIcon(Assets.assetsImagesCoreIcon));
        bodyPartIcons.add('waist');
      }
      if (exercise.movement.bodyPart.contains('legs') && !bodyPartIcons.contains('legs')) {
        bodyParts.add(_getBodyPartIcon(Assets.assetsImagesLegsIcon));
        bodyPartIcons.add('legs');
      }
      if (exercise.movement.bodyPart.contains('cardio') && !bodyPartIcons.contains('cardio')) {
        bodyParts.add(_getBodyPartIcon(Assets.assetsImagesCardioIcon));
        bodyPartIcons.add('cardio');
      }
    }

    if (bodyParts.length > 3) {
      var length = bodyParts.length - 3;
      bodyParts = bodyParts.sublist(0, 3);
      bodyParts.add(
        Text('+$length', style: smallGrey),
      );
    }

    return Row(
      children: bodyParts,
    );
  }

  Widget _getBodyPartIcon(String assetLocation) {
    return Padding(
      padding: const EdgeInsets.only(right: 2),
      child: Image.asset(assetLocation, width: 25, height: 25),
    );
  }

  void _showWorkoutStartBottomSheet(BuildContext context, WorkoutSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return WorkoutStartBottomSheet(session: session, workoutPlanName: workoutPlan.name);
      },
    );
  }
}
