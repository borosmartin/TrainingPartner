import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_detail_page.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/exercises/models/workout_set.dart';
import 'package:training_partner/features/workout/components/widgets/workout_wheel_dialog.dart';

class WorkoutExerciseBody extends StatefulWidget {
  final Exercise exercise;
  final Exercise? previousExercise;
  final PageController pageController;
  final int setNum;
  final Function(int) onCurrentSetIndexChanged;
  final Function(Exercise) onExerciseUpdated;
  final List<Movement> movements;

  const WorkoutExerciseBody({
    super.key,
    required this.exercise,
    this.previousExercise,
    required this.pageController,
    required this.setNum,
    required this.onCurrentSetIndexChanged,
    required this.onExerciseUpdated,
    required this.movements,
  });

  @override
  State<WorkoutExerciseBody> createState() => _WorkoutExerciseBodyState();
}

class _WorkoutExerciseBodyState extends State<WorkoutExerciseBody> {
  late Exercise _exercise;
  PageController get pageController => widget.pageController;
  late int _currentSetNum;

  @override
  void initState() {
    super.initState();
    _currentSetNum = widget.setNum;

    _exercise = widget.exercise.copyWith(workoutSets: widget.previousExercise?.workoutSets ?? widget.exercise.workoutSets);
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
    String subtitle = _exercise.workoutSets.any((element) => element.repetitions == null)
        ? _exercise.workoutSets.first.duration != null
            ? '${TextUtil.firstLetterToUpperCase(_exercise.movement.equipment)}'
                '  -  ${_exercise.workoutSets.first.duration} min'
            : _exercise.workoutSets.first.distance != null
                ? '${TextUtil.firstLetterToUpperCase(_exercise.movement.equipment)}'
                    '  -  ${_exercise.workoutSets.first.distance} km'
                : ''
        : '${TextUtil.firstLetterToUpperCase(_exercise.movement.equipment)}  -  '
            '${_exercise.workoutSets.length} set';

    return Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: widget.movements.firstWhere((movement) => movement.id == _exercise.movement.id).gifUrl,
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
                        builder: (context) => ExerciseDetailPage(movement: _exercise.movement),
                      ));
                    },
                    child: Text(_exercise.movement.name, style: boldLargeAccent),
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

  // todo set num változtató bottom sheet?
  Widget _getSetTable() {
    List<TableRow> tableRows = [];

    switch (_exercise.type) {
      case ExerciseType.repetitions:
        tableRows.add(_getTableRow(workoutSet: _exercise.workoutSets[0], cells: ['#', 'Reps', 'Weight', '']));

        for (int i = 0; i < _exercise.workoutSets.length; i++) {
          tableRows.add(
            _getTableRow(
              setIndex: i,
              workoutSet: _exercise.workoutSets[i],
              cells: [
                (i + 1).toString(),
                _exercise.workoutSets[i].repetitions.toString(),
                _exercise.workoutSets[i].weight == null ? '0 kg' : '${_exercise.workoutSets[i].weight.toString()} kg',
                null,
              ],
            ),
          );
        }
        break;

      case ExerciseType.distance:
        tableRows.addAll([
          _getTableRow(workoutSet: _exercise.workoutSets[0], cells: ['Distance ( km )', '']),
          _getTableRow(
            setIndex: 0,
            workoutSet: _exercise.workoutSets[0],
            cells: ['${_exercise.workoutSets.first.distance} km', null],
          ),
        ]);
        break;

      case ExerciseType.duration:
        tableRows.addAll([
          _getTableRow(workoutSet: _exercise.workoutSets[0], cells: ['Duration ( min )', '']),
          _getTableRow(
            setIndex: 0,
            workoutSet: _exercise.workoutSets[0],
            cells: ['${_exercise.workoutSets.first.duration} min', null],
          ),
        ]);
        break;
    }

    return Table(children: tableRows);
  }

  TableRow _getTableRow({int? setIndex, required WorkoutSet workoutSet, required List<String?> cells}) {
    List<Widget> rowWidgets = [];

    for (int i = 0; i < cells.length; i++) {
      if (setIndex == null || cells[i] == null || setIndex > _currentSetNum) {
        rowWidgets.add(_getTableCell(setIndex: setIndex, label: cells[i], columnIndex: i));
      } else {
        rowWidgets.add(
          GestureDetector(
            onTap: () {
              _showWheelNumberDialog(setIndex, workoutSet);
            },
            child: _getTableCell(label: cells[i], setIndex: setIndex, columnIndex: i),
          ),
        );
      }
    }

    return TableRow(children: rowWidgets);
  }

  Widget _getTableCell({String? label, int? setIndex, required int columnIndex}) {
    bool isRepetitions = _exercise.type == ExerciseType.repetitions;

    if (label == null) {
      if (setIndex != null) {
        if (setIndex == _currentSetNum) {
          return _buildCheckIcon(false);
        } else if (_currentSetNum > setIndex) {
          return _buildCheckIcon(true);
        } else {
          return Container();
        }
      } else {
        return Container();
      }
    } else {
      return Container(
        decoration: BoxDecoration(
          color: setIndex == _currentSetNum ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: columnIndex == 0 ? const Radius.circular(10) : Radius.zero,
            bottomLeft: columnIndex == 0 ? const Radius.circular(10) : Radius.zero,
            topRight: (isRepetitions && columnIndex == 2 || !isRepetitions && columnIndex == 0) ? const Radius.circular(10) : Radius.zero,
            bottomRight: (isRepetitions && columnIndex == 2 || !isRepetitions && columnIndex == 0) ? const Radius.circular(10) : Radius.zero,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Text(label, style: setIndex == _currentSetNum ? boldNormalBlack : normalGrey),
          ),
        ),
      );
    }
  }

  Widget _buildCheckIcon(bool isDone) {
    if (isDone) {
      return const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Icon(Icons.check, color: Colors.black38, size: 25),
      );
    } else {
      return GestureDetector(
        onTap: () {
          setState(() {
            // todo check on non emulator
            HapticFeedback.vibrate();
            _currentSetNum++;
            widget.onCurrentSetIndexChanged(_currentSetNum);
            widget.onExerciseUpdated(_exercise);
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
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
          firstWheelValue: _getFirstWheelValue(workoutSet),
          secondWheelValue: _exercise.type == ExerciseType.repetitions ? workoutSet.weight : null,
          exerciseType: widget.exercise.type,
          onSetButtonPressed: (firsWheelValue, secondWheelValue) => _handleWheelDialogOnChange(setIndex, firsWheelValue, secondWheelValue),
        );
      },
    );
  }

  num? _getFirstWheelValue(WorkoutSet workoutSet) {
    switch (_exercise.type) {
      case ExerciseType.repetitions:
        return workoutSet.repetitions;

      case ExerciseType.distance:
        return workoutSet.distance;

      case ExerciseType.duration:
        return workoutSet.duration;
    }
  }

  void _handleWheelDialogOnChange(int setIndex, num firsWheelValue, num secondWheelValue) {
    switch (_exercise.type) {
      case ExerciseType.repetitions:
        setState(() {
          _exercise.workoutSets[setIndex] = _exercise.workoutSets[setIndex].copyWith(
            repetitions: firsWheelValue,
            weight: secondWheelValue,
          );
        });
        break;

      case ExerciseType.distance:
        setState(() {
          _exercise.workoutSets[setIndex] = _exercise.workoutSets[setIndex].copyWith(
            distance: firsWheelValue,
          );
        });
        break;

      case ExerciseType.duration:
        setState(() {
          _exercise.workoutSets[setIndex] = _exercise.workoutSets[setIndex].copyWith(
            duration: secondWheelValue,
          );
        });
        break;
    }

    widget.onExerciseUpdated(_exercise);
  }
}
