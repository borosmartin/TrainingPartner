import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_detail_page.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/workout_set.dart';
import 'package:training_partner/features/workout/components/widgets/workout_wheel_dialog.dart';

class WorkoutExerciseBody extends StatefulWidget {
  final Exercise exercise;
  final PageController pageController;
  final int setNum;
  final Function(int) onSetValueChange;

  const WorkoutExerciseBody({
    super.key,
    required this.exercise,
    required this.pageController,
    required this.setNum,
    required this.onSetValueChange,
  });

  @override
  State<WorkoutExerciseBody> createState() => _WorkoutExerciseBodyState();
}

class _WorkoutExerciseBodyState extends State<WorkoutExerciseBody> {
  Exercise get exercise => widget.exercise;
  PageController get pageController => widget.pageController;
  late int _currentSetNum;
  late bool _isSetRep;

  @override
  void initState() {
    super.initState();
    _currentSetNum = widget.setNum;
    _isSetRep = exercise.type == ExerciseType.setRep;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _getTitleCard(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _getSetTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getTitleCard() {
    String subtitle = exercise.workoutSets.any((element) => element.repetitions == null)
        ? exercise.workoutSets.first.duration != null
            ? '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}'
                '  -  ${exercise.workoutSets.first.duration} min'
            : exercise.workoutSets.first.distance != null
                ? '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}'
                    '  -  ${exercise.workoutSets.first.distance} km'
                : ''
        : '${TextUtil.firstLetterToUpperCase(exercise.movement.equipment)}  -  '
            '${exercise.workoutSets.length} set';

    return Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: exercise.movement.gifUrl,
              height: 80,
              width: 80,
              placeholder: (context, url) => const ShimmerContainer(height: 80, width: 80),
              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ExerciseDetailPage(movement: exercise.movement),
                      ));
                    },
                    child: Text(exercise.movement.name, style: boldLargeAccent),
                  ),
                  Text(subtitle, style: normalGrey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // todo distance duration
  // todo set num változtató bottom sheet?
  Widget _getSetTable() {
    if (_isSetRep) {
      return Table(
        children: [
          _getTableRow(
            ['#', 'Reps', 'Weight', ''],
            exercise.workoutSets[0],
            -1,
          ),
          for (int i = 0; i < exercise.workoutSets.length; i++)
            _getTableRow(
              [
                (i + 1).toString(),
                exercise.workoutSets[i].repetitions.toString(),
                exercise.workoutSets[i].weight == null ? '0 kg' : '${exercise.workoutSets[i].weight.toString()} kg',
                null,
              ],
              exercise.workoutSets[i],
              i,
            ),
        ],
      );
    } else {
      return Table(
        children: [
          _getTableRow(
            [exercise.workoutSets.first.duration != null || exercise.workoutSets.first.duration != 0 ? 'Duration ( min )' : 'Distance ( km )', ''],
            exercise.workoutSets[0],
            -1,
          ),
          for (int i = 0; i < exercise.workoutSets.length; i++)
            _getTableRow(
              [
                exercise.workoutSets.first.distance == null || exercise.workoutSets.first.distance == 0
                    ? '${exercise.workoutSets.first.duration} min'
                    : '${exercise.workoutSets.first.distance} km',
                null,
              ],
              exercise.workoutSets[i],
              i,
            ),
        ],
      );
    }
  }

  TableRow _getTableRow(List<String?> cells, WorkoutSet workoutSet, int setIndex) {
    List<Widget> rowWidgets = [];

    for (int i = 0; i < cells.length; i++) {
      if (setIndex == -1 || cells[i] == null || setIndex > _currentSetNum) {
        rowWidgets.add(_getTableCell(cells[i], setIndex, i));
      } else {
        rowWidgets.add(
          GestureDetector(
            onTap: () {
              _showWheelNumberDialog(setIndex, workoutSet);
            },
            child: _getTableCell(cells[i], setIndex, i),
          ),
        );
      }
    }

    return TableRow(children: rowWidgets);
  }

  Widget _getTableCell(String? label, int setIndex, int rowIndex) {
    if (label == null) {
      if (setIndex == _currentSetNum) {
        return _buildCheckIcon(false);
      } else if (_currentSetNum > setIndex) {
        return _buildCheckIcon(true);
      } else {
        return Container();
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: setIndex == _currentSetNum ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: rowIndex == 0 ? const Radius.circular(10) : Radius.zero,
          bottomLeft: rowIndex == 0 ? const Radius.circular(10) : Radius.zero,
          topRight: (_isSetRep && rowIndex == 2 || !_isSetRep && rowIndex == 0) ? const Radius.circular(10) : Radius.zero,
          bottomRight: (_isSetRep && rowIndex == 2 || !_isSetRep && rowIndex == 0) ? const Radius.circular(10) : Radius.zero,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Text(
            label,
            style: setIndex == _currentSetNum ? boldNormalBlack : normalGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckIcon(bool isDone) {
    if (isDone) {
      return const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Icon(Icons.check, color: Colors.black38, size: 25),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentSetNum++;

                widget.onSetValueChange(_currentSetNum);

                if (_currentSetNum == exercise.workoutSets.length &&
                    exercise.workoutSets.length > pageController.page!.toInt() &&
                    widget.pageController.hasClients) {
                  pageController.animateToPage(
                    widget.pageController.page!.toInt() + 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }
              });
            },
            // todo icon vékony
            child: const Padding(
              padding: EdgeInsets.all(4.5),
              child: Icon(Icons.check, color: Colors.white, size: 30),
            ),
          ),
        ),
      );
    }
  }

  void _showWheelNumberDialog(int setIndex, WorkoutSet workoutSet) {
    showDialog(
      context: context,
      builder: (context) {
        return WorkoutWheelDialog(
          firstValue: workoutSet.repetitions,
          secondValue: workoutSet.weight,
          exerciseType: widget.exercise.type,
          onSetValuesChange: (firsValue, secondValue) => _handleWheelDialogOnChange(setIndex, firsValue, secondValue),
        );
      },
    );
  }

  void _handleWheelDialogOnChange(int setIndex, num firsValue, num secondValue) {
    if (exercise.type == ExerciseType.setRep) {
      setState(() {
        exercise.workoutSets[setIndex] = exercise.workoutSets[setIndex].copyWith(
          repetitions: firsValue,
          weight: secondValue,
        );
      });
    } else {
      if (exercise.workoutSets.first.duration != null) {
        setState(() {
          exercise.workoutSets[setIndex] = exercise.workoutSets[setIndex].copyWith(
            duration: secondValue,
          );
        });
      } else if (exercise.workoutSets.first.distance != null) {
        setState(() {
          exercise.workoutSets[setIndex] = exercise.workoutSets[setIndex].copyWith(
            distance: firsValue,
          );
        });
      }
    }
  }
}
