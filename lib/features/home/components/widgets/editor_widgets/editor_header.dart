import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/home/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class EditorHeader extends StatefulWidget {
  final List<WorkoutSession> workoutSessions;
  final PageController pageController;
  final TextEditingController workoutPlaneNameController;

  const EditorHeader({
    super.key,
    required this.workoutSessions,
    required this.pageController,
    required this.workoutPlaneNameController,
  });

  @override
  State<EditorHeader> createState() => _EditorHeaderState();
}

class _EditorHeaderState extends State<EditorHeader> {
  @override
  Widget build(BuildContext context) {
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
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: boldNormalGrey),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: widget.workoutPlaneNameController,
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
                GestureDetector(
                  onTap: _handleSaveOnTap,
                  child: Text('Save', style: widget.workoutSessions.isNotEmpty ? boldNormalAccent : boldNormalGrey),
                ),
              ],
            ),
            if (widget.workoutSessions.isNotEmpty) const SizedBox(height: 10),
            if (widget.workoutSessions.isNotEmpty)
              SmoothPageIndicator(
                controller: widget.pageController,
                count: widget.workoutSessions.length,
                effect: WormEffect(
                  type: WormType.thin,
                  activeDotColor: Theme.of(context).colorScheme.tertiary,
                  dotColor: Colors.grey.shade400,
                ),
                onDotClicked: (int index) => widget.pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleSaveOnTap() {
    bool setNumEmptyError = false;
    bool repNumEmptyError = false;
    bool sessionNameEmptyError = false;
    bool exerciseEmptyError = false;
    bool sameNameSessionsError = false;

    List<String> sessionNames = [];
    for (var session in widget.workoutSessions) {
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
          if (exercise.type == ExerciseType.setRep) {
            if (exercise.workoutSets.isEmpty) {
              setNumEmptyError = true;
              break;
            }
            for (var set in exercise.workoutSets) {
              if (set.repetitions == 0) {
                repNumEmptyError = true;
                break;
              }
            }
          }
        }
      }
    }

    if (widget.workoutPlaneNameController.text.isEmpty) {
      _showErrorToast("Error: Workoutplan name can't be empty!");
    } else if (sessionNameEmptyError) {
      _showErrorToast('Error: One of the sessions has no name!');
    } else if (sameNameSessionsError) {
      _showErrorToast('Error: Two sessions has the same name!');
    } else if (exerciseEmptyError) {
      _showErrorToast('Error: One of the sessions has no exercises');
    } else if (setNumEmptyError) {
      _showErrorToast('Error: One of the exercises has no sets');
    } else if (repNumEmptyError) {
      _showErrorToast('Error: One of the sets has no repetition number!');
    } else {
      context.read<WorkoutCubit>().saveWorkoutPlan(
            WorkoutPlan(
              name: widget.workoutPlaneNameController.text,
              sessions: widget.workoutSessions,
            ),
          );

      Navigator.pop(context);
    }
  }

  void _showErrorToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: CustomToast(message: message, type: ToastType.error),
    ));
  }
}
