import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/features/exercises/components/widgets/exercise_group_card.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';
import 'package:training_partner/features/exercises/logic/states/exercise_state.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class ExerciseTypePage extends StatefulWidget {
  const ExerciseTypePage({super.key});

  @override
  State<ExerciseTypePage> createState() => _ExerciseTypePageState();
}

class _ExerciseTypePageState extends State<ExerciseTypePage> {
  @override
  void initState() {
    super.initState();
    context.read<ExerciseCubit>().loadExercises();
    // context.read<ExerciseCubit>().loadExercisesFromCsv();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseCubit, ExerciseState>(
      builder: (context, state) {
        if (state is ExercisesLoading) {
          return _getLoadingBodyContent();
        } else if (state is ExercisesError) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is ExercisesLoaded) {
          return _getBodyContent(state.exercises);
        }

        throw UnimplementedError();
      },
    );
  }

  Widget _getLoadingBodyContent() {
    return const Padding(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Column(children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ShimmerContainer(height: 160, width: 160),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ShimmerContainer(height: 160, width: 160),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ShimmerContainer(height: 160, width: 160),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ShimmerContainer(height: 160, width: 160),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ShimmerContainer(height: 160, width: 160),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ShimmerContainer(height: 160, width: 160),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ShimmerContainer(height: 160, width: 160),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ShimmerContainer(height: 160, width: 160),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _getBodyContent(List<Movement> exercises) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Column(children: [
        Expanded(
          child: Row(
            children: [
              ExerciseGroupCard(
                label: 'Chest',
                assetLocation: 'assets/images/chest_icon.png',
                groupName: 'Chest',
                movements: _getChestMovements(exercises),
              ),
              ExerciseGroupCard(
                label: 'Arms',
                assetLocation: 'assets/images/arms_icon.png',
                groupName: 'Arms',
                movements: _getArmsMovements(exercises),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              ExerciseGroupCard(
                label: 'Shoulders',
                assetLocation: 'assets/images/shoulder_icon.png',
                groupName: 'Shoulders',
                movements: _getShouldersMovements(exercises),
              ),
              ExerciseGroupCard(
                label: 'Back',
                assetLocation: 'assets/images/back_icon.png',
                groupName: 'Back',
                movements: _getBackMovements(exercises),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              ExerciseGroupCard(
                label: 'Core',
                assetLocation: 'assets/images/core_icon.png',
                groupName: 'Core',
                movements: _getCoreMovements(exercises),
              ),
              ExerciseGroupCard(
                label: 'Legs',
                assetLocation: 'assets/images/legs_icon.png',
                groupName: 'Legs',
                movements: _getLegMovements(exercises),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              ExerciseGroupCard(
                label: 'Cardio',
                assetLocation: 'assets/images/cardio_icon.jpg',
                groupName: 'Cardio',
                movements: _getCardioMovements(exercises),
              ),
              // TODO create all icon (combine all maybe?)
              ExerciseGroupCard(
                label: 'All',
                assetLocation: 'assets/images/back_icon.png',
                groupName: 'All',
                movements: exercises,
              ),
            ],
          ),
        ),
      ]),
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
