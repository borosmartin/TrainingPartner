import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/exercises/components/widgets/exercise_group_card.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/generated/assets.dart';

class ExerciseTypePage extends StatelessWidget {
  final List<Movement> movements;

  const ExerciseTypePage({super.key, required this.movements});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _getHeader(),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _getBodyContent(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getHeader() {
    return const Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.personWalking),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Exercises', style: boldLargeBlack),
          ),
        ],
      ),
    );
  }

  Widget _getBodyContent() {
    return Column(
      children: [
        Row(
          children: [
            ExerciseGroupCard(
              label: 'C H E S T',
              assetLocation: Assets.imagesChestIcon,
              groupName: 'Chest',
              movements: _getChestMovements(),
            ),
            const SizedBox(width: 10),
            ExerciseGroupCard(
              label: 'A R M S',
              assetLocation: Assets.imagesArmsIcon,
              groupName: 'Arms',
              movements: _getArmsMovements(),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ExerciseGroupCard(
              label: 'S H O U L D E R S',
              assetLocation: Assets.imagesShoulderIcon,
              groupName: 'Shoulders',
              movements: _getShouldersMovements(),
            ),
            const SizedBox(width: 10),
            ExerciseGroupCard(
              label: 'B A C K',
              assetLocation: Assets.imagesBackIcon,
              groupName: 'Back',
              movements: _getBackMovements(),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ExerciseGroupCard(
              label: 'C O R E',
              assetLocation: Assets.imagesCoreIcon,
              groupName: 'Core',
              movements: _getCoreMovements(),
            ),
            const SizedBox(width: 10),
            ExerciseGroupCard(
              label: 'L E G S',
              assetLocation: Assets.imagesLegsIcon,
              groupName: 'Legs',
              movements: _getLegMovements(),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ExerciseGroupCard(
              label: 'C A R D I O',
              assetLocation: Assets.imagesCardioIcon,
              groupName: 'Cardio',
              movements: _getCardioMovements(),
            ),
            const SizedBox(width: 10),
            // TODO create all icon (combine all maybe?)
            ExerciseGroupCard(
              label: 'A L L',
              assetLocation: Assets.imagesChestIcon,
              groupName: 'All',
              movements: movements,
            ),
          ],
        ),
      ],
    );
  }

  List<Movement> _getChestMovements() {
    var list = movements.where((movement) => movement.bodyPart == 'chest').toList();
    return list;
  }

  List<Movement> _getArmsMovements() {
    var list = movements.where((movement) => movement.bodyPart.contains('arms')).toList();
    return list;
  }

  List<Movement> _getShouldersMovements() {
    var list = movements.where((movement) => movement.bodyPart == 'shoulders').toList();
    return list;
  }

  List<Movement> _getBackMovements() {
    var list = movements.where((movement) => movement.bodyPart == 'back').toList();
    return list;
  }

  List<Movement> _getCoreMovements() {
    var list = movements.where((movement) => movement.bodyPart == 'waist').toList();
    return list;
  }

  List<Movement> _getLegMovements() {
    var list = movements.where((movement) => movement.bodyPart.contains('legs')).toList();
    return list;
  }

  List<Movement> _getCardioMovements() {
    return movements.where((movement) => movement.bodyPart.contains('cardio')).toList();
  }
}
