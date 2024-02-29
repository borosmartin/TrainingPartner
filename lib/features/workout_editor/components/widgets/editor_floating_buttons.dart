import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

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
      children: [
        if (workoutSessions.isNotEmpty)
          FloatingActionButton(
            heroTag: 'removeSession',
            shape: defaultCornerShape,
            backgroundColor: isLoading ? Colors.grey : Colors.red,
            onPressed: isLoading ? null : onRemoveTap,
            elevation: 1,
            tooltip: 'Remove session',
            child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 35),
          ),
        const SizedBox(height: 15),
        FloatingActionButton(
          heroTag: 'addSession',
          shape: defaultCornerShape,
          backgroundColor: isLoading ? Colors.grey : Theme.of(context).colorScheme.tertiary,
          onPressed: isLoading ? null : onAddTap,
          elevation: 1,
          tooltip: 'Add new session',
          child: const Icon(Icons.post_add_rounded, color: Colors.white, size: 35),
        ),
      ],
    );
  }
}
