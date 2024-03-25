import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_button.dart';
import 'package:training_partner/core/resources/widgets/custom_input_field.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout/components/widgets/time_line_widget.dart';
import 'package:training_partner/features/workout/components/widgets/workout_exercise_body.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutPage extends StatefulWidget {
  final WorkoutSession session;
  final WorkoutSession? previousSession;
  final List<Movement> movements;

  const WorkoutPage({
    super.key,
    required this.session,
    this.previousSession,
    required this.movements,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  WorkoutSession get session => widget.session;
  late PageController _pageController;
  late Timer timer;
  int _currentPageIndex = 0;

  Map<String, int> setNumbers = {};

  int _seconds = 0;

  // TODO REMOVE LATER
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);

    colorSafeArea(color: Colors.white);
    _startTimer();
    _fillEmptyFields();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _getBodyContent(),
      ),
    );
  }

  Widget _getBodyContent() {
    List<String> errors = _getErrors();

    return Column(
      children: [
        _getHeaderWidget(),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: session.exercises.length,
            itemBuilder: (context, index) {
              return WorkoutExerciseBody(
                exercise: session.exercises[index],
                previousExercise: _getPreviousExercise(session.exercises[index]),
                pageController: _pageController,
                setNum: setNumbers[session.exercises[index].movement.id] ?? 0,
                onCurrentSetIndexChanged: (setNum) => handleOnCurrentSetIndexChanged(setNum, session.exercises[index]),
                onExerciseUpdated: (Exercise updatedExercise) {
                  Exercise updated = updatedExercise;
                  session.exercises[_currentPageIndex] = updated;
                },
                movements: widget.movements,
              );
            },
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
          ),
        ),
        if (_currentPageIndex == session.exercises.length - 1)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomInputField(inputController: dateController, hintText: 'TEST: DATE'),
          ),
        if (_currentPageIndex == session.exercises.length - 1)
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Row(
              children: [
                if (errors.isNotEmpty) _getErrorWidget(errors),
                Flexible(
                  child: CustomTitleButton(
                    icon: Iconsax.medal_star5,
                    label: 'Finish Workout',
                    isEnabled: errors.isEmpty,
                    onTap: () {
                      var sessionWithDuration = session.copyWith(durationInSeconds: _seconds, date: DateTime.now());

                      if (dateController.text.isNotEmpty) {
                        sessionWithDuration = sessionWithDuration.copyWith(date: DateTimeUtil.TESTstringToDate(dateController.text));
                      }

                      context.read<WorkoutCubit>().saveWorkoutSession(sessionWithDuration);

                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _getHeaderWidget() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomBackButton(dialog: _getBackDialog()),
                Text(DateTimeUtil.secondsToDigitalFormat(_seconds), style: boldLargeBlack),
                const Icon(FontAwesomeIcons.bullseye, color: Colors.transparent, size: 43),
              ],
            ),
            TimeLineWidget(
              session: session,
              currentExerciseIndex: _currentPageIndex,
              onExerciseClick: (int index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // todo kicsit szépíteni
  Widget _getBackDialog() {
    return Dialog(
      elevation: 0,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_rounded),
                SizedBox(width: 5),
                Text('Warning', style: boldNormalBlack),
              ],
            ),
            const Text('Are you sure you want to cancel the current workout?', style: normalGrey),
            const SizedBox(height: 15),
            Row(
              children: [
                CustomButton(
                  label: 'No',
                  isOutlined: true,
                  onTap: () => Navigator.pop(context),
                ),
                const Spacer(),
                CustomButton(
                  label: 'Yes',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Exercise? _getPreviousExercise(Exercise currentExercise) {
    Exercise? previousExercise;
    if (widget.previousSession != null) {
      for (var exercise in widget.previousSession!.exercises) {
        if (exercise.movement.id == currentExercise.movement.id) {
          previousExercise = exercise;
        }
      }
    }

    return previousExercise;
  }

  Widget _getErrorWidget(List<String> errors) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        color: Colors.red,
        child: InkWell(
          onTap: () => showBottomToast(context: context, message: errors.first, type: ToastType.error),
          borderRadius: defaultBorderRadius,
          child: const Padding(
            padding: EdgeInsets.all(18),
            child: Icon(Icons.error, color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<String> _getErrors() {
    List<String> errors = [];
    for (int i = 0; i < session.exercises.length; i++) {
      for (int j = 0; j < session.exercises[i].workoutSets.length; j++) {
        if (session.exercises[i].type == ExerciseType.repetitions) {
          if (session.exercises[i].workoutSets[j].weight == 0 || session.exercises[i].workoutSets[j].repetitions == 0) {
            errors.add('Error: The exercise "${session.exercises[i].movement.name}" is not yet completed!');
            break;
          }
        } else if (session.exercises[i].type == ExerciseType.distance) {
          if (session.exercises[i].workoutSets[j].distance == 0) {
            errors.add('Error: The exercise "${session.exercises[i].movement.name}" is not yet completed!');
            break;
          }
        } else if (session.exercises[i].type == ExerciseType.duration) {
          if (session.exercises[i].workoutSets[j].duration == 0) {
            errors.add('Error: The exercise "${session.exercises[i].movement.name}" is not yet completed!');
            break;
          }
        }
      }
    }

    for (var exercise in session.exercises) {
      if (setNumbers.containsKey(exercise.movement.id)) {
        int completedSets = setNumbers[exercise.movement.id] ?? 0;

        if (completedSets < exercise.workoutSets.length) {
          errors.add('Error: The exercise "${exercise.movement.name}" is not yet completed!');
        }
      } else {
        errors.add('Error: Exercise "${exercise.movement.name}" has no completed sets!');
      }
    }

    return errors;
  }

  void handleOnCurrentSetIndexChanged(int setNum, Exercise exercise) {
    setState(() {
      setNumbers[exercise.movement.id] = setNum;

      int completedExercises = 0;
      int nextPageIndex = 0;

      for (var exercise in session.exercises) {
        if (setNumbers.containsKey(exercise.movement.id)) {
          int completedSets = setNumbers[exercise.movement.id] ?? 0;

          if (completedSets == exercise.workoutSets.length) {
            completedExercises++;
            nextPageIndex = session.exercises.indexWhere((exercise) => setNumbers[exercise.movement.id] != exercise.workoutSets.length);
          } else {
            nextPageIndex = session.exercises.indexWhere((exercise) => setNumbers[exercise.movement.id] != exercise.workoutSets.length);
          }
        }
      }

      if (completedExercises == session.exercises.length) {
        nextPageIndex = session.exercises.length + 1;
      }

      if (setNum == exercise.workoutSets.length && _pageController.hasClients) {
        _pageController.animateToPage(
          nextPageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _fillEmptyFields() {
    for (int i = 0; i < session.exercises.length; i++) {
      for (int j = 0; j < session.exercises[i].workoutSets.length; j++) {
        if (session.exercises[i].type == ExerciseType.repetitions) {
          if (session.exercises[i].workoutSets[j].weight == null) {
            session.exercises[i].workoutSets[j] = session.exercises[i].workoutSets[j].copyWith(weight: 0);
          }
        } else if (session.exercises[i].type == ExerciseType.distance) {
          if (session.exercises[i].workoutSets[j].distance == null) {
            session.exercises[i].workoutSets[j] = session.exercises[i].workoutSets[j].copyWith(distance: 0.0);
          }
        } else if (session.exercises[i].type == ExerciseType.duration) {
          if (session.exercises[i].workoutSets[j].duration == null) {
            session.exercises[i].workoutSets[j] = session.exercises[i].workoutSets[j].copyWith(duration: 0);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();

    timer.cancel();

    super.dispose();
  }
}
