import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_search_bar.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/features/exercises/logic/cubits/movement_cubit.dart';
import 'package:training_partner/features/exercises/logic/states/movement_state.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout_editor/components/widgets/movement_filter_bottom_sheet.dart';
import 'package:training_partner/features/workout_editor/components/widgets/selectable_movement_card.dart';
import 'package:training_partner/features/workout_editor/models/movement_filter.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class ExercisePickerPage extends StatefulWidget {
  final WorkoutSession session;
  final List<Movement> allMovements;
  final void Function(String) onRename;
  final void Function(List<Exercise>) onExercisesChanged;

  const ExercisePickerPage({
    super.key,
    required this.session,
    required this.onRename,
    required this.allMovements,
    required this.onExercisesChanged,
  });

  @override
  State<ExercisePickerPage> createState() => _ExercisePickerPageState();
}

class _ExercisePickerPageState extends State<ExercisePickerPage> {
  List<Exercise> _selectedExercises = [];
  MovementFilter? _movementFilter;

  final TextEditingController _searchController = TextEditingController();
  FToast toast = FToast();

  @override
  void initState() {
    super.initState();

    _selectedExercises = List.from(widget.session.exercises);

    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        // todo not working, fekete lesz mikor visszalépek
        onPopInvoked: (value) => colorSafeArea(color: Colors.white),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text('Exercises', style: boldLargeBlack),
            actions: [
              IconButton(
                onPressed: () => _showExerciseFiltersBottomSheet(context),
                icon: Icon(
                  Icons.filter_alt_rounded,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              )
            ],
          ),
          body: BlocConsumer<MovementCubit, MovementState>(
            listener: (BuildContext context, MovementState state) {
              if (state is MovementsError) {
                showBottomToast(
                  context: context,
                  message: state.errorMessage,
                  type: ToastType.error,
                );
                Navigator.pop(context);
              }
            },
            builder: (BuildContext context, MovementState state) {
              if (state is MovementsLoading || state is MovementsUninitialized || state is MovementsError) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is MovementsLoaded) {
                _movementFilter = state.previousFilter;
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      CustomSearchBar(
                        hintText: 'Search...',
                        onChanged: (value) => context.read<MovementCubit>().filterMovements(
                              widget.allMovements,
                              state.previousFilter != null ? state.previousFilter!.copyWith(searchQuery: value) : MovementFilter(searchQuery: value),
                            ),
                        textController: _searchController,
                        backgroundColor: Colors.white,
                        iconColor: Colors.black,
                        textStyle: smallBlack,
                      ),
                      const SizedBox(height: 10),
                      _getMovementList(state),
                      const SizedBox(height: 10),
                      CustomTitleButton(
                        label: 'Select ( ${_selectedExercises.length} )',
                        onPressed: () {
                          widget.onExercisesChanged(_selectedExercises);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }

              throw UnimplementedError();
            },
          ),
        ),
      ),
    );
  }

  // todo a kiválaszott movements nem elől vannak
  Widget _getMovementList(MovementsLoaded state) {
    if (state.previousFilter != null && state.filteredMovements != null && state.filteredMovements!.isEmpty) {
      return const Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 30, color: Colors.black38),
            SizedBox(width: 5),
            Text('No exercise found', style: boldNormalGrey),
          ],
        ),
      );
    } else if (state.previousFilter != null && state.filteredMovements != null) {
      return Expanded(
        child: ListView.builder(
          itemCount: state.filteredMovements!.length,
          itemBuilder: (context, index) {
            final movement = state.filteredMovements![index];
            final isSelected = _selectedExercises.any((exercise) => exercise.movement.id == movement.id);

            return SelectableMovementCard(
              movement: movement,
              isSelected: isSelected,
              onSelect: (isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedExercises.add(Exercise(
                      movement: movement,
                      type: ExerciseType.repetitions,
                      workoutSets: const [],
                    ));
                  } else {
                    _selectedExercises.removeWhere((exercise) => exercise.movement.id == movement.id);
                  }
                });
              },
            );
          },
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: state.movements.length,
          itemBuilder: (context, index) {
            final movement = state.movements[index];
            final isSelected = _selectedExercises.any((exercise) => exercise.movement.id == movement.id);

            return SelectableMovementCard(
              movement: movement,
              isSelected: isSelected,
              onSelect: (isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedExercises.add(Exercise(
                      movement: movement,
                      type: ExerciseType.repetitions,
                      workoutSets: const [],
                    ));
                  } else {
                    _selectedExercises.removeWhere((exercise) => exercise.movement.id == movement.id);
                  }
                });
              },
            );
          },
        ),
      );
    }
  }

  void _showExerciseFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return MovementFilterBottomSheet(
          allMovements: widget.allMovements,
          previousFilter: _movementFilter,
        );
      },
    );
  }
}
