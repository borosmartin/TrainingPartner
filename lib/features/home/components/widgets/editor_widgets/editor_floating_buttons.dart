import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/widgets/custom_small_button.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class EditorFloatingButtons extends StatelessWidget {
  final List<WorkoutSession> workoutSessions;
  final bool isLoading;
  final VoidCallback onRemoveTap;
  final VoidCallback onAddTap;

  const EditorFloatingButtons({
    super.key,
    required this.workoutSessions,
    required this.isLoading,
    required this.onAddTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (workoutSessions.isNotEmpty)
          CustomSmallButton(
            elevation: 1,
            backgroundColor: isLoading ? Colors.grey : Colors.red,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 35,
            ),
            onTap: isLoading ? null : onRemoveTap,
          ),
        const SizedBox(height: 15),
        CustomSmallButton(
          elevation: 1,
          backgroundColor: isLoading ? Colors.grey : Theme.of(context).colorScheme.tertiary,
          icon: const Icon(Icons.post_add_rounded, color: Colors.white, size: 35),
          onTap: isLoading ? null : onAddTap,
        ),
      ],
    );
  }
}
