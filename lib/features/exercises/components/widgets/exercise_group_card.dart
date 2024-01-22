import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/exercises/components/pages/grouped_exercises_page.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class ExerciseGroupCard extends StatelessWidget {
  final String label;
  final String assetLocation;
  final String groupName;
  final List<Movement> movements;

  const ExerciseGroupCard({
    super.key,
    required this.label,
    required this.assetLocation,
    required this.groupName,
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GroupedExercisesPage(
              groupName: groupName,
              movements: movements,
              assetLocation: assetLocation,
            ),
          ),
        ),
        child: Card(
          shape: defaultCornerShape,
          margin: const EdgeInsets.all(10),
          elevation: 0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(assetLocation, height: 90, width: 90),
                const SizedBox(height: 10),
                Text(label, style: boldNormalBlack),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
