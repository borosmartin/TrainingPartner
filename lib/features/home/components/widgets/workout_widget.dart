import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/features/home/components/widgets/workout_actions_button.dart';
import 'package:training_partner/features/home/components/widgets/workout_dropdown.dart';
import 'package:training_partner/features/home/components/widgets/workout_session_list.dart';
import 'package:training_partner/features/workout_editor/components/pages/workout_editor_page.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class WorkoutWidget extends StatefulWidget {
  final List<WorkoutPlan>? workoutPlans;
  final WorkoutPlan? selectedWorkoutPlan;
  final void Function(WorkoutPlan) onSelect;

  const WorkoutWidget({
    super.key,
    required this.workoutPlans,
    required this.selectedWorkoutPlan,
    required this.onSelect,
  });

  @override
  State<WorkoutWidget> createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  @override
  Widget build(BuildContext context) {
    // todo finish this
    if (widget.workoutPlans == null || widget.workoutPlans!.isEmpty) {
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
                builder: (context) => const WorkoutEditorPage(),
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
                    workoutPlans: widget.workoutPlans!,
                    onSelect: widget.onSelect,
                  ),
                  const SizedBox(width: 5),
                  const CustomDivider(isVertical: true, color: Colors.white),
                  const SizedBox(width: 5),
                  WorkoutPlanActionsButton(workoutPlan: widget.selectedWorkoutPlan),
                  const SizedBox(width: 5),
                ],
              ),
            ),
          ),
          WorkoutSessionList(workoutPlan: widget.selectedWorkoutPlan!),
        ],
      ),
    );
  }
}
