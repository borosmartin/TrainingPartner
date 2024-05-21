import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_list_page.dart';
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
      child: Card(
        shape: defaultCornerShape,
        elevation: 0,
        child: InkWell(
          borderRadius: defaultBorderRadius,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExerciseListPage(
                groupName: groupName,
                movements: movements,
                assetLocation: assetLocation,
              ),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    assetLocation,
                    height: 85,
                    width: 85,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  decoration: const BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          label,
                          style: CustomTextStyle.bodyTetriary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
