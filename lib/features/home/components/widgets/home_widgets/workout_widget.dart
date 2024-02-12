import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/home/components/pages/workout_editor_page.dart';
import 'package:training_partner/features/home/components/widgets/home_widgets/workout_actions_button.dart';
import 'package:training_partner/features/home/components/widgets/home_widgets/workout_dropdown.dart';
import 'package:training_partner/features/home/components/widgets/home_widgets/workout_session_list.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';
import 'package:training_partner/generated/assets.dart';

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
          Lottie.asset(Assets.animationsDumbbells, width: 300, height: 200),
          const Text('No workout plans yet, you can create a new one!', style: boldNormalGrey),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WorkoutPlanDropdown(
                workoutPlans: widget.workoutPlans!,
                onSelect: widget.onSelect,
              ),
              const SizedBox(width: 10),
              WorkoutPlanActionsButton(workoutPlan: widget.selectedWorkoutPlan),
            ],
          ),
          WorkoutSessionList(sessions: widget.selectedWorkoutPlan!.sessions),
        ],
      ),
    );
  }
}
