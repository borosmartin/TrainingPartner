import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/core/resources/widgets/custom_action_chip.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_search_bar.dart';
import 'package:training_partner/core/resources/widgets/custom_small_button.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/components/widgets/equipment_dropdown.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';
import 'package:training_partner/features/exercises/logic/states/exercise_state.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/selectable_movement_card.dart';
import 'package:training_partner/features/home/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class WorkoutEditorPage2 extends StatefulWidget {
  final WorkoutPlan? workoutPlan;

  const WorkoutEditorPage2({
    super.key,
    this.workoutPlan,
  });

  @override
  State<WorkoutEditorPage2> createState() => _WorkoutEditorPage2State();
}

class _WorkoutEditorPage2State extends State<WorkoutEditorPage2> {
  WorkoutPlan? workoutPlan;
  List<WorkoutSession> workoutSessions = [];
  WorkoutSession? selectedSession;

  List<Movement> selectedMovements = [];
  List<Movement> filteredMovements = [];
  final List<String> selectedTargets = [];

  TextEditingController workoutPlaneNameController = TextEditingController();
  TextEditingController sessionNameController = TextEditingController();
  TextEditingController exerciseNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  late PageController pageController;

  bool isLoading = true;
  bool areExerciseFiltersVisible = false;
  String? selectedEquipment;

  @override
  void initState() {
    super.initState();

    colorSafeArea(color: Colors.white);
    context.read<ExerciseCubit>().loadExercises();
    pageController = PageController();

    workoutPlan = widget.workoutPlan;
    if (workoutPlan != null) {
      workoutPlaneNameController.text = workoutPlan!.name;
      workoutSessions = workoutPlan!.sessions;
    } else {
      workoutPlaneNameController.text = 'My workoutplan';
    }

    selectedSession = workoutSessions.isNotEmpty ? workoutSessions.first : null;
    if (selectedSession != null) {
      sessionNameController.text = selectedSession!.name;
    } else {
      sessionNameController.text = 'New session';
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
                  onTap: () => Navigator.pop(context),
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
    // todo finish this
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
                      TextField(
                        controller: sessionNameController,
                        style: boldLargeGrey,
                        cursorColor: Theme.of(context).colorScheme.tertiary,
                        decoration: InputDecoration(
                          filled: false,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.edit, color: Colors.black45, size: 20),
                          ),
                          alignLabelWithHint: false,
                          prefixIconConstraints: const BoxConstraints(),
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

                      // SUBTITLES
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
                  onPressed: () => _showExerciseBottomSheet(allMovements),
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
      return Column(children: [
        for (var exercise in session.exercises) Text(exercise.movement.name),
      ]);
    }
  }

  void _showExerciseBottomSheet(List<Movement> allMovements) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 0,
                        color: Colors.black26,
                        child: SizedBox(
                          height: 5,
                          width: 80,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomBackButton(color: Colors.black38),
                      const Text('Exercises', style: boldLargeBlack),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            areExerciseFiltersVisible = !areExerciseFiltersVisible;
                          });
                        },
                        // todo icon
                        icon: Icon(
                          Icons.filter_alt_rounded,
                          color: areExerciseFiltersVisible ? Theme.of(context).colorScheme.tertiary : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  CustomSearchBar(
                    textController: exerciseNameController,
                    hintText: 'Search...',
                    onChanged: (value) => {},
                  ),
                  const SizedBox(height: 10),
                  _getFilterWidgets(allMovements),
                  Expanded(
                    child: ListView.builder(
                      itemCount: allMovements.length,
                      itemBuilder: (context, index) {
                        return SelectableMovementCard(
                          movement: allMovements[index],
                          onSelectChanged: (isSelected) {
                            if (isSelected) {
                              selectedMovements.add(allMovements[index]);
                            } else {
                              selectedMovements.remove(allMovements[index]);
                            }
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTitleButton(
                    label: 'Add selected ( ${selectedMovements.length} )',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      setState(() {
        areExerciseFiltersVisible = false;
      });
    });
  }

  Widget _getFilterWidgets(List<Movement> allMovements) {
    return Visibility(
      visible: areExerciseFiltersVisible,
      child: Column(
        children: [
          const DividerWithText(text: 'Equipment', textStyle: smallGrey),
          const SizedBox(height: 10),
          EquipmentDropdown(
            equipments: getEquipments(allMovements),
            initialItem: 'All',
            onSelect: (value) {
              setState(() {
                selectedEquipment = value.toLowerCase();
              });
              filterMovements(allMovements);
            },
          ),
          _buildTargetRow(allMovements),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTargetRow(List<Movement> allMovements) {
    List<Widget> targets = [];

    var targetNames = allMovements.map((movement) => movement.target).toSet().toList();
    var isTargetVisible = targetNames.length > 2;

    for (var target in targetNames) {
      targets.add(
        CustomActionChip(
          label: target,
          onTap: (isActive, label) {
            setState(() {
              if (!isActive) {
                selectedTargets.remove(label);
                filterMovements(allMovements);
              } else {
                selectedTargets.add(label);
                filterMovements(allMovements);
              }
            });
          },
        ),
      );
    }

    return isTargetVisible
        ? Column(
            children: [
              const SizedBox(height: 10),
              const DividerWithText(text: 'Targets', textStyle: smallGrey),
              const SizedBox(height: 10),
              SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: targets)),
            ],
          )
        : Container();
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
                    int newIndex = workoutSessions.length + 1;
                    WorkoutSession session = WorkoutSession(
                      id: generateRandomId(),
                      name: 'New session $newIndex',
                      exercises: const [],
                    );
                    workoutSessions.add(session);

                    sessionNameController.text = 'New session $newIndex';
                    context.read<WorkoutCubit>().saveWorkoutSession(currentUser.email!, session);
                  });
          },
        ),
      ],
    );
  }

  void filterMovements(List<Movement> allMovements) {
    setState(() {
      filteredMovements = allMovements.where((movement) {
        final containsSearchText = searchController.text.isEmpty || movement.name.toLowerCase().contains(searchController.text.toLowerCase());

        final matchesEquipment = selectedEquipment == 'all' || selectedEquipment == null || movement.equipment == selectedEquipment;

        final matchesTargets = selectedTargets.isEmpty || selectedTargets.contains(movement.target);

        return containsSearchText && matchesEquipment && matchesTargets;
      }).toList();
    });
  }

  List<String> getEquipments(List<Movement> allMovements) {
    var equipments = allMovements
        .map(
          (movement) => TextUtil.firstLetterToUpperCase(movement.equipment),
        )
        .toSet()
        .toList();

    equipments.add('All');
    equipments.sort((a, b) => a.compareTo(b));
    return equipments;
  }

  String generateRandomId() {
    Random random = Random();
    return (100 + random.nextInt(900)).toString();
  }
}
