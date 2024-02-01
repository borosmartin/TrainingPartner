import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_small_button.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';
import 'package:training_partner/features/exercises/logic/states/exercise_state.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/home/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class Editor extends StatefulWidget {
  final WorkoutPlan? workoutPlan;

  const Editor({
    super.key,
    this.workoutPlan,
  });

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late WorkoutCubit _workoutCubit;

  WorkoutPlan? workoutPlan;
  // todo idik indexű page -> currentSession?
  List<WorkoutSession> workoutSessions = [];
  WorkoutSession? selectedSession;

  int currentPage = 0;

  TextEditingController workoutPlaneNameController = TextEditingController();
  TextEditingController sessionNameController = TextEditingController();

  late PageController pageController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    colorSafeArea(color: Colors.white);

    _workoutCubit = context.read<WorkoutCubit>();
    context.read<ExerciseCubit>().loadExercises();

    pageController = PageController();

    workoutPlan = widget.workoutPlan;
    if (workoutPlan != null) {
      workoutPlaneNameController.text = workoutPlan!.name;
      workoutSessions = workoutPlan!.sessions;
      selectedSession = workoutSessions.first;
    } else {
      workoutPlaneNameController.text = 'My workoutplan';
    }
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
            body: _getBodyContent(),
            floatingActionButton: _getFloatingButtons(),
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
            _getHeader(),
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
            _getHeader(),
            const SizedBox(height: 10),
            _getSessionList(state.movements),
          ],
        );
      }

      throw UnimplementedError();
    });
  }

  Widget _getHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // todo kell akkor hive?
                    _workoutCubit.deleteAllWorkoutSession();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: boldNormalGrey),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: workoutPlaneNameController,
                    style: boldLargeBlack,
                    textAlign: TextAlign.center,
                    cursorColor: Theme.of(context).colorScheme.tertiary,
                    decoration: InputDecoration(
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                      fillColor: Theme.of(context).colorScheme.primary,
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // todo
                GestureDetector(
                  onTap: () => {},
                  child: Text(
                    'Save',
                    style: workoutSessions.isNotEmpty ? boldNormalAccent : boldNormalGrey,
                  ),
                ),
              ],
            ),
            if (workoutSessions.isNotEmpty) const SizedBox(height: 10),
            if (workoutSessions.isNotEmpty)
              SmoothPageIndicator(
                controller: pageController,
                count: workoutSessions.length,
                effect: WormEffect(
                  type: WormType.thin,
                  activeDotColor: Theme.of(context).colorScheme.tertiary,
                  dotColor: Colors.grey.shade400,
                ),
                onDotClicked: (int index) => pageController.jumpToPage(index),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getSessionList(List<Movement> allMovements) {
    // todo finish
    if (workoutSessions.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('No sessions yet, you can create a new one!', style: boldNormalGrey),
        ),
      );
    } else {
      return Expanded(
        child: PageView.builder(
          controller: pageController,
          itemCount: workoutSessions.length,
          onPageChanged: (int index) {
            setState(() {
              selectedSession = workoutSessions[index];
              currentPage = index;
            });
          },
          itemBuilder: (context, index) {
            return _getSessionDetails(workoutSessions[index], allMovements);
          },
        ),
      );
    }
  }

  Widget _getSessionDetails(WorkoutSession session, List<Movement> allMovements) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // TITLE
                      GestureDetector(
                        onTap: () => _showRenameBottomSheet(session),
                        child: Row(
                          children: [
                            const Icon(Icons.edit, color: Colors.black45, size: 20),
                            const SizedBox(width: 10),
                            Text(workoutSessions[currentPage].name, style: boldLargeGrey),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text('${session.exercises.length} exercises', style: smallGrey),
                          const SizedBox(width: 10),
                          Text('${session.exercises.length} sets', style: smallGrey),
                        ],
                      ),
                    ],
                  ),
                ),

                // EXERCISE BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    shape: defaultCornerShape,
                    elevation: 0,
                    padding: const EdgeInsets.all(13),
                  ),
                  // onPressed: () => _showExerciseBottomSheet(allMovements),
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.fitness_center, size: 26, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Exercises', style: boldNormalWhite),
                    ],
                  ),
                ),
              ],
            ),
            _getExerciseList(session),
          ],
        ),
      ),
    );
  }

  Widget _getExerciseList(WorkoutSession session) {
    if (session.exercises.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 200),
          //todo icon
          Icon(Icons.accessibility_rounded, size: 80, color: Colors.black38),
          Text('No exercises yet, add a few!', style: boldNormalGrey),
        ],
      );
    } else {
      return Center(
        child: Text('Session name: ${session.name}'),
      );
    }
  }

  Widget _getFloatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (workoutSessions.isNotEmpty)
          CustomSmallButton(
            elevation: 1,
            backgroundColor: isLoading ? Colors.grey : Colors.red,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 35,
            ),
            // todo add remove
            onTap: isLoading ? null : () {},
          ),
        const SizedBox(height: 15),
        CustomSmallButton(
          elevation: 1,
          backgroundColor: isLoading ? Colors.grey : Theme.of(context).colorScheme.tertiary,
          icon: const Icon(Icons.post_add_rounded, color: Colors.white, size: 35),
          onTap: () {
            isLoading
                ? null
                : setState(() {
                    WorkoutSession session = WorkoutSession(
                      id: generateUniqueId(),
                      name: 'New session',
                      exercises: const [],
                    );

                    workoutSessions.add(session);
                    sessionNameController.text = session.name;
                  });
          },
        ),
      ],
    );
  }

  void _showRenameBottomSheet(WorkoutSession session) {
    sessionNameController.text = session.name;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Card(
                    elevation: 0,
                    color: Colors.black26,
                    child: SizedBox(
                      height: 5,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Rename session', style: boldLargeBlack),
                  const SizedBox(height: 20),
                  TextField(
                    controller: sessionNameController,
                    style: smallGrey,
                    cursorColor: Theme.of(context).colorScheme.tertiary,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.drive_file_rename_outline_outlined, color: Colors.black45),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      hintStyle: smallGrey,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      border: const OutlineInputBorder(
                        borderRadius: defaultBorderRadius,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: defaultBorderRadius,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: defaultBorderRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTitleButton(
                      label: 'Rename',
                      onTap: () {
                        setState(() {
                          workoutSessions[currentPage] = session.copyWith(
                            name: sessionNameController.text,
                          );

                          pageController.jumpToPage(currentPage);
                        });

                        setState(() {});
                        Navigator.of(context).pop();
                      }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
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
