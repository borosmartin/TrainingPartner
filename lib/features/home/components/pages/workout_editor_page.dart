import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';
import 'package:training_partner/features/exercises/logic/states/exercise_state.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/exercises/models/workout_set.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/editor_exercise_card.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/editor_floating_buttons.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/editor_header.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/session_header.dart';
import 'package:training_partner/features/home/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/home/logic/states/workout_states.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class WorkoutEditorPage extends StatefulWidget {
  final WorkoutPlan? workoutPlan;

  const WorkoutEditorPage({super.key, this.workoutPlan});

  @override
  State<WorkoutEditorPage> createState() => _WorkoutEditorPageState();
}

class _WorkoutEditorPageState extends State<WorkoutEditorPage> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  WorkoutPlan? workoutPlan;
  TextEditingController workoutPlaneNameController = TextEditingController();
  List<WorkoutSession> workoutSessions = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);

    context.read<ExerciseCubit>().loadMovements();

    workoutPlan = widget.workoutPlan;
    if (workoutPlan != null) {
      workoutSessions = workoutPlan!.sessions;
      workoutPlaneNameController.text = workoutPlan!.name;
    } else {
      workoutPlaneNameController.text = 'New workout';
    }

    colorSafeArea(color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) => colorSafeArea(color: Theme.of(context).colorScheme.background),
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            floatingActionButton: EditorFloatingButtons(
              workoutSessions: workoutSessions,
              isLoading: isLoading,
              onAddTap: _addNewWorkoutSession,
              onRemoveTap: _removeWorkoutSession,
            ),
            body: _getBodyContent(),
          ),
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return BlocListener<WorkoutCubit, WorkoutState>(
      listener: (context, state) {
        if (state is WorkoutPlanCreationSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content:
                CustomToast(message: widget.workoutPlan != null ? 'Workout plan updated!' : 'New workout plan created!', type: ToastType.success),
          ));
        } else if (state is WorkoutPlanDeleteSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: CustomToast(message: 'Workout plan deleted!', type: ToastType.success),
          ));
        } else if (state is WorkoutPlanDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: CustomToast(message: 'Error: ${state.message}', type: ToastType.error),
          ));
        } else if (state is WorkoutPlanCreationError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: CustomToast(message: 'Error: ${state.message}', type: ToastType.error),
          ));
        }
      },
      child: BlocConsumer<ExerciseCubit, ExerciseState>(listener: (context, state) {
        if (state is MovementsLoaded) {
          setState(() {
            isLoading = false;
          });
        }
      }, builder: (context, state) {
        if (state is MovementsLoading) {
          return Column(
            children: [
              EditorHeader(
                workoutSessions: workoutSessions,
                pageController: _pageController,
                workoutPlaneNameController: workoutPlaneNameController,
              ),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          );
        } else if (state is MovementsError) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        } else if (state is MovementsLoaded) {
          return Column(
            children: [
              EditorHeader(
                workoutSessions: workoutSessions,
                pageController: _pageController,
                workoutPlaneNameController: workoutPlaneNameController,
              ),
              const SizedBox(height: 20),
              _getSessionPageView(state.movements),
            ],
          );
        }

        throw UnimplementedError();
      }),
    );
  }

  Widget _getSessionPageView(List<Movement> movements) {
    if (workoutSessions.isEmpty) {
      return const Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Text('No sessions yet, create a new one!', style: boldNormalGrey),
          ),
        ),
      );
    } else {
      return Expanded(
        child: PageView.builder(
          controller: _pageController,
          itemCount: workoutSessions.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SessionHeader(
                    session: workoutSessions[index],
                    allMovements: movements,
                    onRename: (newName) {
                      setState(() {
                        workoutSessions[index] = workoutSessions[index].copyWith(name: newName);
                      });
                    },
                    onExercisesChanged: (newExercises) {
                      setState(() {
                        workoutSessions[index] = workoutSessions[index].copyWith(exercises: newExercises);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _getExerciseList(workoutSessions[index]),
                  const SizedBox(height: 15),
                ],
              ),
            );
          },
          onPageChanged: (int index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
        ),
      );
    }
  }

  // todo change order of selected exercies with drag and drop?, and delete on swipe
  Widget _getExerciseList(WorkoutSession session) {
    if (session.exercises.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 170),
          Icon(Icons.accessibility_rounded, size: 80, color: Colors.black38),
          Text('No exercises yet, add a few!', style: boldNormalGrey),
        ],
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: session.exercises.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                EditorExerciseCard(
                  exercise: session.exercises[index],
                  isFirst: index == 0,
                  isLast: index == session.exercises.length - 1,
                  exerciseList: session.exercises,
                  onRemoveExercise: () {
                    setState(() {
                      session.exercises.removeAt(index);
                    });
                  },
                  onChangeType: () {
                    setState(() {
                      if (session.exercises[index].type == ExerciseType.setRep) {
                        session.exercises[index] = session.exercises[index].copyWith(exerciseType: ExerciseType.distanceDuration);
                      } else {
                        session.exercises[index] = session.exercises[index].copyWith(exerciseType: ExerciseType.setRep);
                      }
                    });
                  },
                  onSetValuesChange: (setDistance, repDuration) {
                    setState(() {
                      session.exercises[index] = session.exercises[index].copyWith(
                        workoutSets: _createWorkoutSets(session.exercises[index], setDistance, repDuration),
                      );
                    });
                  },
                ),
                if (index == session.exercises.length - 1 && session.exercises.length > 2)
                  Container(
                    height: 145,
                    color: Colors.transparent,
                  ),
              ],
            );
          },
        ),
      );
    }
  }

  List<WorkoutSet> _createWorkoutSets(Exercise exercise, int setDistance, int repDuration) {
    List<WorkoutSet> sets = [];

    if (exercise.type == ExerciseType.setRep) {
      if (setDistance != 0) {
        if (repDuration == 0) {
          for (int i = 0; i < setDistance; i++) {
            sets.add(const WorkoutSet());
          }
        } else {
          for (int i = 0; i < setDistance; i++) {
            sets.add(WorkoutSet(repetitions: repDuration));
          }
        }
      }
    } else {
      sets.add(WorkoutSet(distance: setDistance, duration: repDuration));
    }

    return sets;
  }

  void _addNewWorkoutSession() {
    setState(() {
      int newIndex = workoutSessions.length;
      workoutSessions.add(WorkoutSession(
        id: _generateUniqueId(),
        name: 'New session',
        exercises: const [],
      ));

      _currentPageIndex = newIndex;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    });
  }

  void _removeWorkoutSession() {
    setState(() {
      if (workoutSessions.isNotEmpty) {
        workoutSessions.removeAt(_currentPageIndex);
        if (_currentPageIndex > 0) {
          _currentPageIndex--;
        }
      }
    });
  }

  String _generateUniqueId() {
    Random random = Random();
    bool isUnique = false;
    int newId = 0;

    List<String> existingIds = [];
    for (var session in workoutSessions) {
      existingIds.add(session.id);
    }

    while (!isUnique) {
      newId = 100 + random.nextInt(900);
      String newIdString = newId.toString();

      if (!existingIds.contains(newIdString)) {
        isUnique = true;
      }
    }

    return newId.toString();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
