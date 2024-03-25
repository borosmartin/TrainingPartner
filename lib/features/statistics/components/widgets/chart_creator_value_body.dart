import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_search_bar.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/logic/cubits/movement_cubit.dart';
import 'package:training_partner/features/exercises/logic/states/movement_state.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
import 'package:training_partner/features/workout_editor/components/widgets/selectable_movement_card.dart';
import 'package:training_partner/features/workout_editor/models/movement_filter.dart';

class ChartCreatorValueBody extends StatefulWidget {
  final ChartBuilderChartType type;
  final List<Movement> movements;
  final Function(String?) onValueSelected;

  const ChartCreatorValueBody({
    Key? key,
    required this.type,
    required this.movements,
    required this.onValueSelected,
  }) : super(key: key);

  @override
  State<ChartCreatorValueBody> createState() => _ChartCreatorValueBodyState();
}

class _ChartCreatorValueBodyState extends State<ChartCreatorValueBody> {
  final TextEditingController _searchController = TextEditingController();
  List<Movement> get movements => widget.movements;
  String? selectedExerciseId;
  int? selectedMuscleIndex;

  @override
  Widget build(BuildContext context) {
    return _getBodyContent();
  }

  Widget _getBodyContent() {
    if (widget.type == ChartBuilderChartType.muscle) {
      Map<int, String> muscles = _getMuscles();

      List<Widget> muscleWidgets = [];
      for (var entry in muscles.entries) {
        muscleWidgets.add(_getMuscleCard(index: entry.key, name: entry.value));
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: muscleWidgets.sublist(0, muscleWidgets.length ~/ 2),
          ),
          Column(
            children: muscleWidgets.sublist(muscleWidgets.length ~/ 2),
          ),
        ],
      );
    } else {
      return BlocBuilder<MovementCubit, MovementState>(
        builder: (BuildContext context, MovementState state) {
          if (state is MovementsLoading || state is MovementsUninitialized || state is MovementsError) {
            return const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is MovementsLoaded) {
            double height = (MediaQuery.of(context).size.height + 200) / 2;

            return Column(
              children: [
                CustomSearchBar(
                  hintText: 'Search...',
                  onChanged: (value) => context.read<MovementCubit>().filterMovements(
                        widget.movements,
                        state.previousFilter != null ? state.previousFilter!.copyWith(searchQuery: value) : MovementFilter(searchQuery: value),
                      ),
                  textController: _searchController,
                  backgroundColor: Colors.white,
                  iconColor: Colors.black,
                  textStyle: smallBlack,
                ),
                const SizedBox(height: 10),
                SizedBox(height: height, child: _getMovementList(state)),
              ],
            );
          }

          throw UnimplementedError();
        },
      );
    }
  }

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
            final isSelected = selectedExerciseId != null && selectedExerciseId == movement.id;

            return SelectableMovementCard(
              movement: movement,
              isSelected: isSelected,
              onSelect: (isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedExerciseId = movement.id;
                    widget.onValueSelected(selectedExerciseId);
                  } else {
                    selectedExerciseId = null;
                    widget.onValueSelected(null);
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
            final isSelected = selectedExerciseId != null && selectedExerciseId == movement.id;

            return SelectableMovementCard(
              movement: movement,
              isSelected: isSelected,
              onSelect: (isSelected) {
                setState(() {
                  if (isSelected) {
                    selectedExerciseId = movement.id;
                    widget.onValueSelected(selectedExerciseId);
                  } else {
                    selectedExerciseId = null;
                    widget.onValueSelected(null);
                  }
                });
              },
            );
          },
        ),
      );
    }
  }

  Widget _getMuscleCard({required int index, required String name}) {
    double width = (MediaQuery.of(context).size.width - 70) / 2;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedMuscleIndex == index) {
            selectedMuscleIndex = null;
          } else {
            selectedMuscleIndex = index;
          }

          widget.onValueSelected(selectedMuscleIndex != null ? name : null);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: SizedBox(
          width: width,
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: defaultBorderRadius,
              side: BorderSide(color: selectedMuscleIndex == index ? Theme.of(context).colorScheme.tertiary : Colors.transparent, width: 2.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Text(
                  name,
                  style: selectedMuscleIndex == index ? boldNormalAccent : boldNormalGrey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<int, String> _getMuscles() {
    Map<int, String> muscles = {};

    int index = 0;
    for (int i = 0; i < movements.length; i++) {
      if (movements[i].bodyPart != 'cardio') {
        if (!muscles.values.contains(movements[i].target)) {
          muscles[index] = movements[i].target;
          index++;
        }
      }
    }

    for (int i = 0; i < muscles.length; i++) {
      muscles[i] = TextUtil.firstLetterToUpperCase(muscles.values.elementAt(i));
    }

    muscles = Map.fromEntries(muscles.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));

    return muscles;
  }
}
