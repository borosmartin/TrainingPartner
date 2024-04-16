import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/open_ai/gpt_cubit.dart';
import 'package:training_partner/core/resources/open_ai/gpt_message.dart';
import 'package:training_partner/core/resources/widgets/colored_safe_area_body.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/exercises/models/workout_set.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/workout_editor/components/widgets/editor_exercise_card.dart';
import 'package:training_partner/features/workout_editor/components/widgets/editor_floating_buttons.dart';
import 'package:training_partner/features/workout_editor/components/widgets/editor_header.dart';
import 'package:training_partner/features/workout_editor/components/widgets/session_header.dart';
import 'package:training_partner/features/workout_editor/logic/cubits/workout_plan_cubit.dart';
import 'package:training_partner/features/workout_editor/logic/states/workout_plan_states.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutEditorPage extends StatefulWidget {
  final WorkoutPlan? workoutPlan;
  final List<Movement> movements;
  final AppSettings settings;

  const WorkoutEditorPage({
    super.key,
    this.workoutPlan,
    required this.movements,
    required this.settings,
  });

  @override
  State<WorkoutEditorPage> createState() => _WorkoutEditorPageState();
}

class _WorkoutEditorPageState extends State<WorkoutEditorPage> {
  List<Movement> get movements => widget.movements;

  late PageController _pageController;
  int _currentPageIndex = 0;

  WorkoutPlan? workoutPlan;
  TextEditingController workoutPlaneNameController = TextEditingController();
  List<WorkoutSession> workoutSessions = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);

    workoutPlan = widget.workoutPlan;
    if (workoutPlan != null) {
      workoutSessions = workoutPlan!.sessions;
      workoutPlaneNameController.text = workoutPlan!.name;

      context.read<GptCubit>().getGptResponse(workoutPlan!, _getTipPromtString());
    } else {
      workoutPlaneNameController.text = 'New workout';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: EditorFloatingButtons(
          workoutSessions: workoutSessions,
          onAddTap: _addNewWorkoutSession,
          onRemoveTap: _removeWorkoutSession,
        ),
        body: ColoredSafeAreaBody(
          safeAreaColor: Theme.of(context).cardColor,
          isLightTheme: Theme.of(context).brightness == Brightness.light,
          child: _getBodyContent(),
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return BlocListener<WorkoutPlanCubit, WorkoutPlanState>(
      listener: (context, state) {
        if (state is WorkoutPlanCreationSuccessful) {
          showBottomToast(
            context: context,
            message: widget.workoutPlan != null ? 'Workout plan updated!' : 'New workout plan created!',
            type: ToastType.success,
          );
        } else if (state is WorkoutPlanDeleteSuccessful) {
          showBottomToast(
            context: context,
            message: 'Workout plan deleted!',
            type: ToastType.success,
          );
        } else if (state is WorkoutPlanDeleteError) {
          showBottomToast(
            context: context,
            message: 'Error: ${state.message}',
            type: ToastType.error,
          );
        } else if (state is WorkoutPlanCreationError) {
          showBottomToast(
            context: context,
            message: 'Error: ${state.message}',
            type: ToastType.error,
          );
        }
      },
      child: Column(
        children: [
          EditorHeader(
            workoutSessions: workoutSessions,
            pageController: _pageController,
            workoutPlaneNameController: workoutPlaneNameController,
            workoutPlan: workoutPlan,
          ),
          const SizedBox(height: 20),
          _getSessionPageView(movements),
        ],
      ),
    );
  }

  Widget _getSessionPageView(List<Movement> movements) {
    if (workoutSessions.isEmpty) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Text('No sessions yet, create a new one!', style: CustomTextStyle.subtitleSecondary(context)),
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

  Widget _getExerciseList(WorkoutSession session) {
    if (session.exercises.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 170),
          Icon(FontAwesomeIcons.personRunning, size: 80, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 10),
          Text('No exercises yet, add a few!', style: CustomTextStyle.subtitleSecondary(context)),
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
                  movements: movements,
                  isFirst: index == 0,
                  isLast: index == session.exercises.length - 1,
                  onRemoveExercise: () {
                    setState(() {
                      session.exercises.removeAt(index);
                    });
                  },
                  onChangeType: () {
                    setState(() {
                      switch (session.exercises[index].type) {
                        case ExerciseType.repetitions:
                          session.exercises[index] = session.exercises[index].copyWith(exerciseType: ExerciseType.distance);
                          break;
                        case ExerciseType.distance:
                          session.exercises[index] = session.exercises[index].copyWith(exerciseType: ExerciseType.duration);
                          break;
                        case ExerciseType.duration:
                          session.exercises[index] = session.exercises[index].copyWith(exerciseType: ExerciseType.repetitions);
                          break;
                      }
                    });
                  },
                  onValuesChange: (firstWheelValue, secondWheelValue) {
                    setState(() {
                      session.exercises[index] = session.exercises[index].copyWith(
                        workoutSets: _createWorkoutSets(session.exercises[index], firstWheelValue, secondWheelValue),
                      );
                    });
                  },
                  settings: widget.settings,
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

  List<WorkoutSet> _createWorkoutSets(Exercise exercise, num firstWheelValue, num secondWheelValue) {
    List<WorkoutSet> sets = [];

    switch (exercise.type) {
      case ExerciseType.repetitions:
        if (firstWheelValue != 0) {
          if (secondWheelValue != 0) {
            for (int i = 0; i < firstWheelValue; i++) {
              sets.add(WorkoutSet(repetitions: secondWheelValue));
            }
          } else {
            sets.add(const WorkoutSet());
          }
        }
        break;

      case ExerciseType.distance:
        sets.add(WorkoutSet(distance: firstWheelValue));
        break;

      case ExerciseType.duration:
        sets.add(WorkoutSet(duration: firstWheelValue));
        break;
    }

    return sets;
  }

  void _addNewWorkoutSession() {
    List<String> existingIds = [];
    for (var session in workoutSessions) {
      existingIds.add(session.id);
    }

    setState(() {
      int newIndex = workoutSessions.length;
      workoutSessions.add(WorkoutSession(
        id: TextUtil.generateUniqueId(existingIds),
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

  List<GptMessage> _getTipPromtString() {
    List<GptMessage> messages = [];

    String tipPromt =
        "This prompt is designed to analyze the provided workout routine and generate specific tips for improvement. Keep responses concise and focused on potential mistakes in the routine. Ensure each tip addresses specific aspects of the workout, such as muscle targeting, rep and set counts, and weekly volume. Ensure each exercise adequately targets specific muscle groups; for instance, check if any major muscle group is overlooked in the routine. Avoid generic advice and prioritize insights tailored to the given routine. Give at most 3 tips. Here is the workout routine to base your analysis on:";

    for (var session in workoutSessions) {
      String sessionName = session.name;
      tipPromt += "\nWorkout name: $sessionName\nExerices:\n";
      for (var exercise in session.exercises) {
        tipPromt += "${exercise.movement.name}: ${exercise.workoutSets.length} sets of ${exercise.workoutSets[0].repetitions} reps\n";
      }
    }

    messages.add(GptMessage(role: 'user', content: tipPromt));

    return messages;
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }
}
