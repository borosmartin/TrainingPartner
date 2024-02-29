import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class WorkoutPlanDropdown extends StatelessWidget {
  final List<WorkoutPlan> workoutPlans;
  final Function(WorkoutPlan) onSelect;

  const WorkoutPlanDropdown({super.key, required this.workoutPlans, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    String initalName = workoutPlans.firstWhere((plan) => plan.isActive, orElse: () => workoutPlans.first).name;
    // todo ha csak egy workoutplan van akkor fehér a háttere, amin a fehér betű nem szerencsés
    return Expanded(
      child: CustomDropdown<String>(
        initialItem: initalName,
        items: workoutPlans.map((plan) => plan.name).toList(),
        excludeSelected: true,
        decoration: CustomDropdownDecoration(
          closedFillColor: Theme.of(context).colorScheme.tertiary,
          expandedFillColor: Theme.of(context).colorScheme.tertiary,
          closedSuffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, size: 25, color: Colors.white),
          expandedSuffixIcon: const Icon(Icons.keyboard_arrow_up_rounded, size: 25, color: Colors.white),
          listItemStyle: TextUtil.getCustomTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          headerStyle: normalWhite,
          closedBorderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
          ),
        ),
        onChanged: (selectedName) {
          final selectedPlan = workoutPlans.firstWhere((plan) => plan.name == selectedName);
          onSelect(selectedPlan);
        },
      ),
    );
  }
}
