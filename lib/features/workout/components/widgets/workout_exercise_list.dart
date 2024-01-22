import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class WorkoutExerciseList extends StatelessWidget {
  final List<Exercise> exercises;
  const WorkoutExerciseList({super.key, required this.exercises});

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const Center(
        child: Text("No session selected", style: smallBlack),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            return _getExerciseRow(context, exercises[index]);
          },
        ),
      );
    }
  }

  Widget _getExerciseRow(BuildContext context, Exercise exercise) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Icon(
          Icons.fitness_center,
          size: 35,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        title: Text(exercise.movement.name, style: boldNormalBlack),
        subtitle: Text(exercise.movement.bodyPart, style: smallGrey),
      ),
    );
  }
}
