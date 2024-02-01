import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';
import 'package:training_partner/features/exercises/logic/states/exercise_state.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/editor_floating_buttons.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/editor_header.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/session_widget.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class WorkoutEditorPage extends StatefulWidget {
  const WorkoutEditorPage({super.key});

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

    context.read<ExerciseCubit>().loadExercises();

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
              onAddTap: addNewWorkoutSession,
              onRemoveTap: removeWorkoutSession,
            ),
            body: _getBodyContent(),
          ),
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return BlocConsumer<ExerciseCubit, ExerciseState>(listener: (context, state) {
      if (state is ExercisesLoaded) {
        setState(() {
          isLoading = false;
        });
      }
    }, builder: (context, state) {
      if (state is ExercisesLoading) {
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
      } else if (state is ExercisesError) {
        return Center(child: Text('Error: ${state.errorMessage}'));
      } else if (state is ExercisesLoaded) {
        return Column(
          children: [
            EditorHeader(
              workoutSessions: workoutSessions,
              pageController: _pageController,
              workoutPlaneNameController: workoutPlaneNameController,
            ),
            const SizedBox(height: 15),
            _getSessionPageView(state.movements),
          ],
        );
      }

      throw UnimplementedError();
    });
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
            return SessionWidget(
              session: workoutSessions[index],
              movements: movements,
              onRename: (newName) {
                setState(() {
                  workoutSessions[index] = workoutSessions[index].copyWith(name: newName);
                });
              },
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

  void addNewWorkoutSession() {
    setState(() {
      int newIndex = workoutSessions.length;
      workoutSessions.add(WorkoutSession(
        id: generateUniqueId(),
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

  void removeWorkoutSession() {
    setState(() {
      if (workoutSessions.isNotEmpty) {
        workoutSessions.removeAt(_currentPageIndex);
        if (_currentPageIndex > 0) {
          _currentPageIndex--;
        }
      }
    });
  }

  String generateUniqueId() {
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
}
