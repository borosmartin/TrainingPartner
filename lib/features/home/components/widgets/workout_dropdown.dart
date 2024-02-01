import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';

class WorkoutPlanDropdown extends StatelessWidget {
  final List<WorkoutPlan> workoutPlans;
  final Function(WorkoutPlan) onSelect;

  const WorkoutPlanDropdown({super.key, required this.workoutPlans, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomDropdown<String>(
        initialItem: workoutPlans.firstWhere((plan) => plan.isActive).name,
        items: workoutPlans.map((plan) => plan.name).toList(),
        excludeSelected: true,
        decoration: const CustomDropdownDecoration(
          closedSuffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 27),
          expandedSuffixIcon: Icon(Icons.keyboard_arrow_up_rounded, size: 27),
          listItemStyle: boldLargeGrey,
          headerStyle: boldLargeGrey,
          closedBorderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
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
