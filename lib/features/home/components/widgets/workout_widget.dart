import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/home/components/widgets/workout_actions_button.dart';
import 'package:training_partner/features/home/components/widgets/workout_dropdown.dart';
import 'package:training_partner/features/home/components/widgets/workout_session_list.dart';
import 'package:training_partner/features/workout_editor/components/pages/workout_editor_page.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutWidget extends StatelessWidget {
  final List<WorkoutPlan>? workoutPlans;
  final List<WorkoutSession> previousSessions;
  final WorkoutPlan? selectedWorkoutPlan;
  final void Function(WorkoutPlan) onSelect;
  final List<Movement> movements;

  const WorkoutWidget({
    super.key,
    required this.workoutPlans,
    required this.previousSessions,
    required this.selectedWorkoutPlan,
    required this.onSelect,
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    // todo finish this
    if (workoutPlans == null || workoutPlans!.isEmpty) {
      return Column(
        children: [
          const DividerWithText(text: 'Workout plan', textStyle: normalGrey),
          const SizedBox(height: 15),
          const Icon(Iconsax.note_215, size: 85, color: Colors.black38),
          const Text('No workout plans yet, create a new one!', style: boldNormalGrey),
          const SizedBox(height: 20),
          CustomTitleButton(
            label: 'Create',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WorkoutEditorPage(movements: movements),
              ),
            ),
          ),
        ],
      );
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const DividerWithText(text: 'Workout plan', textStyle: normalGrey),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 15),
                  const Icon(Iconsax.note_215, size: 30, color: Colors.white),
                  const SizedBox(width: 5),
                  WorkoutPlanDropdown(
                    workoutPlans: workoutPlans!,
                    onSelect: onSelect,
                  ),
                  const SizedBox(width: 5),
                  const CustomDivider(isVertical: true, color: Colors.white),
                  const SizedBox(width: 5),
                  WorkoutPlanActionsButton(workoutPlan: selectedWorkoutPlan, movements: movements),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
          WorkoutSessionList(
            workoutPlan: selectedWorkoutPlan!,
            previousSessions: previousSessions,
            movements: movements,
          ),
        ],
      ),
    );
  }
}
