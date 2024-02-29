import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/features/exercises/components/widgets/exercise_group_card.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';
import 'package:training_partner/features/exercises/logic/states/exercise_state.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/generated/assets.dart';

class ExerciseTypePage extends StatefulWidget {
  const ExerciseTypePage({super.key});

  @override
  State<ExerciseTypePage> createState() => _ExerciseTypePageState();
}

class _ExerciseTypePageState extends State<ExerciseTypePage> {
  @override
  void initState() {
    super.initState();
    context.read<ExerciseCubit>().loadMovements();
  }

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
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        if (state is MovementsLoading) {
          return _getExerciseCards();
        } else if (state is MovementsError) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is MovementsLoaded) {
          return _getExerciseCards(movements: state.movements);
        }

        throw UnimplementedError();
      },
    );
  }

  Widget _getExerciseCards({List<Movement>? movements}) {
    bool isLoading = movements == null;
    Widget loadingWidget = const Padding(padding: EdgeInsets.all(10), child: ShimmerContainer(height: 160, width: 160));

    return Column(
      children: [
        Row(
          children: [
            isLoading
                ? loadingWidget
                : ExerciseGroupCard(
                    label: 'C H E S T',
                    assetLocation: Assets.imagesChestIcon,
                    groupName: 'Chest',
                    movements: _getChestMovements(movements),
                  ),
            const SizedBox(width: 10),
            isLoading
                ? loadingWidget
                : ExerciseGroupCard(
                    label: 'A R M S',
                    assetLocation: Assets.imagesArmsIcon,
                    groupName: 'Arms',
                    movements: _getArmsMovements(movements),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            isLoading
                ? loadingWidget
                : ExerciseGroupCard(
                    label: 'S H O U L D E R S',
                    assetLocation: Assets.imagesShoulderIcon,
                    groupName: 'Shoulders',
                    movements: _getShouldersMovements(movements),
                  ),
            const SizedBox(width: 10),
            isLoading
                ? loadingWidget
                : ExerciseGroupCard(
                    label: 'B A C K',
                    assetLocation: Assets.imagesBackIcon,
                    groupName: 'Back',
                    movements: _getBackMovements(movements),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            isLoading
                ? loadingWidget
                : ExerciseGroupCard(
                    label: 'C O R E',
                    assetLocation: Assets.imagesCoreIcon,
                    groupName: 'Core',
                    movements: _getCoreMovements(movements),
                  ),
            const SizedBox(width: 10),
            isLoading
                ? loadingWidget
                : ExerciseGroupCard(
                    label: 'L E G S',
                    assetLocation: Assets.imagesLegsIcon,
                    groupName: 'Legs',
                    movements: _getLegMovements(movements),
                  ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            isLoading
                ? loadingWidget
                : ExerciseGroupCard(
                    label: 'C A R D I O',
                    assetLocation: Assets.imagesCardioIcon,
                    groupName: 'Cardio',
                    movements: _getCardioMovements(movements),
                  ),
            const SizedBox(width: 10),

            // TODO create all icon (combine all maybe?)
            isLoading
                ? loadingWidget
                : ExerciseGroupCard(
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

  List<Movement> _getChestMovements(List<Movement> exercises) {
    var list = exercises.where((movement) => movement.bodyPart == 'chest').toList();
    return list;
  }

  List<Movement> _getArmsMovements(List<Movement> exercises) {
    var list = exercises.where((movement) => movement.bodyPart.contains('arms')).toList();
    return list;
  }

  List<Movement> _getShouldersMovements(List<Movement> exercises) {
    var list = exercises.where((movement) => movement.bodyPart == 'shoulders').toList();
    return list;
  }

  List<Movement> _getBackMovements(List<Movement> exercises) {
    var list = exercises.where((movement) => movement.bodyPart == 'back').toList();
    return list;
  }

  List<Movement> _getCoreMovements(List<Movement> exercises) {
    var list = exercises.where((movement) => movement.bodyPart == 'waist').toList();
    return list;
  }

  List<Movement> _getLegMovements(List<Movement> exercises) {
    var list = exercises.where((movement) => movement.bodyPart.contains('legs')).toList();
    return list;
  }

  List<Movement> _getCardioMovements(List<Movement> exercises) {
    return exercises.where((movement) => movement.bodyPart.contains('cardio')).toList();
  }
}
