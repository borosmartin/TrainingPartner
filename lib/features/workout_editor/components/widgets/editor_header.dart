import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/workout_editor/components/widgets/gpt_tip_widget.dart';
import 'package:training_partner/features/workout_editor/logic/cubits/workout_plan_cubit.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class EditorHeader extends StatefulWidget {
  final List<WorkoutSession> workoutSessions;
  final PageController pageController;
  final TextEditingController workoutPlaneNameController;
  final WorkoutPlan? workoutPlan;

  const EditorHeader({
    super.key,
    required this.workoutSessions,
    required this.pageController,
    required this.workoutPlaneNameController,
    this.workoutPlan,
  });

  @override
  State<EditorHeader> createState() => _EditorHeaderState();
}

class _EditorHeaderState extends State<EditorHeader> {
  List<WorkoutSession> get sessions => widget.workoutSessions;
  bool isTipVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<WorkoutPlanCubit>().getAllWorkoutPlan();
                    Navigator.pop(context);
                  },
                  child: CustomBackButton(context: context),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: widget.workoutPlaneNameController,
                    style: CustomTextStyle.titlePrimary(context),
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
                IconButton(
                    onPressed: _handleSaveOnTap,
                    icon: const Icon(
                      FontAwesomeIcons.floppyDisk,
                      color: accentColor,
                      size: 25,
                    )),
              ],
            ),
          ),
          if (sessions.isNotEmpty) const SizedBox(height: 10),
          if (sessions.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: GestureDetector(
                    onTap: widget.workoutPlan == null
                        ? null
                        : () {
                            setState(() {
                              isTipVisible = !isTipVisible;
                            });
                          },
                    child: Icon(
                      isTipVisible ? FontAwesomeIcons.lightbulb : FontAwesomeIcons.solidLightbulb,
                      color: widget.workoutPlan == null ? Colors.transparent : const Color(0xFF28a08c),
                    ),
                  ),
                ),
                SmoothPageIndicator(
                  controller: widget.pageController,
                  count: sessions.length,
                  effect: WormEffect(
                    type: WormType.thin,
                    activeDotColor: accentColor,
                    dotColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onDotClicked: (int index) => widget.pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Icon(
                    FontAwesomeIcons.solidLightbulb,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 15),
          if (widget.workoutPlan != null)
            GptTipWidget(
              isTipVisible: isTipVisible,
              onTap: () {
                setState(() {
                  isTipVisible = !isTipVisible;
                });
              },
            ),
        ],
      ),
    );
  }

  void _handleSaveOnTap() {
    bool setNumEmptyError = false;
    bool repNumEmptyError = false;
    bool sessionNameEmptyError = false;
    bool exerciseEmptyError = false;
    bool sameNameSessionsError = false;
    bool distanceEmptyError = false;
    bool durationEmptyError = false;

    List<String> sessionNames = [];
    for (var session in sessions) {
      if (session.name.isEmpty) {
        sessionNameEmptyError = true;
        break;
      }

      if (sessionNames.contains(session.name)) {
        sameNameSessionsError = true;
        break;
      }
      sessionNames.add(session.name);

      if (session.exercises.isEmpty) {
        exerciseEmptyError = true;
      } else {
        for (var exercise in session.exercises) {
          if (exercise.type == ExerciseType.repetitions) {
            if (exercise.workoutSets.isEmpty) {
              setNumEmptyError = true;
              break;
            }
            for (var set in exercise.workoutSets) {
              if (set.repetitions == 0 || set.repetitions == null) {
                repNumEmptyError = true;
                break;
              }
            }
          } else if (exercise.type == ExerciseType.distance) {
            if (exercise.workoutSets.isEmpty) {
              setNumEmptyError = true;
              break;
            } else {
              if (exercise.workoutSets.first.distance == 0 || exercise.workoutSets.first.distance == null) {
                distanceEmptyError = true;
              }
            }
          } else {
            if (exercise.workoutSets.isEmpty) {
              setNumEmptyError = true;
              break;
            } else {
              if (exercise.workoutSets.first.duration == 0 || exercise.workoutSets.first.duration == null) {
                durationEmptyError = true;
              }
            }
          }
        }
      }
    }

    if (sessions.isEmpty) {
      showBottomToast(context: context, message: "Error: Add at least one session!", type: ToastType.error);
    } else if (widget.workoutPlaneNameController.text.isEmpty) {
      showBottomToast(context: context, message: "Error: Workoutplan name can't be empty!", type: ToastType.error);
    } else if (sessionNameEmptyError) {
      showBottomToast(context: context, message: 'Error: One of the sessions has no name!', type: ToastType.error);
    } else if (sameNameSessionsError) {
      showBottomToast(context: context, message: 'Error: Two sessions has the same name!', type: ToastType.error);
    } else if (exerciseEmptyError) {
      showBottomToast(context: context, message: 'Error: One of the sessions has no exercises', type: ToastType.error);
    } else if (setNumEmptyError) {
      showBottomToast(context: context, message: 'Error: One of the exercises has no sets', type: ToastType.error);
    } else if (repNumEmptyError) {
      showBottomToast(context: context, message: 'Error: One of the exercises has no repetition number!', type: ToastType.error);
    } else if (distanceEmptyError) {
      showBottomToast(context: context, message: 'Error: One of the exercises has no distance set!', type: ToastType.error);
    } else if (durationEmptyError) {
      showBottomToast(context: context, message: 'Error: One of the exercises has no duration set!', type: ToastType.error);
    } else {
      context.read<WorkoutPlanCubit>().createWorkoutPlan(WorkoutPlan(name: widget.workoutPlaneNameController.text, sessions: sessions));

      Navigator.pop(context);
    }
  }
}
