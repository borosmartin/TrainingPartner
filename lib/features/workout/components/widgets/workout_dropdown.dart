import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/workout/models/workout_plan.dart';

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
        decoration: const CustomDropdownDecoration(
          listItemStyle: normalBlack,
          headerStyle: normalBlack,
        ),
        onChanged: (selectedName) {
          final selectedPlan = workoutPlans.firstWhere((plan) => plan.name == selectedName);
          onSelect(selectedPlan);
        },
      ),
    );
  }
}
