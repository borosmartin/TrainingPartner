import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_button.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/workout/components/widgets/time_line_widget.dart';
import 'package:training_partner/features/workout/components/widgets/timer_widget.dart';
import 'package:training_partner/features/workout/components/widgets/workout_exercise_body.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutPage extends StatefulWidget {
  final WorkoutSession session;

  const WorkoutPage({super.key, required this.session});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  WorkoutSession get session => widget.session;
  late PageController _pageController;
  int _currentPageIndex = 0;

  Map<String, int> setNumbers = {};

  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);

    colorSafeArea(color: Colors.white);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _getBodyContent(),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        // todo fix
        floatingActionButton: const TimerWidget(),
      ),
    );
  }

  Widget _getBodyContent() {
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
                pageController: _pageController,
                setNum: setNumbers[session.exercises[index].movement.id] ?? 0,
                onSetValueChange: (setNum) {
                  setNumbers[session.exercises[index].movement.id] = setNum;
                },
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
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Row(
              children: [
                const SizedBox(width: 80),
                Flexible(
                  child: CustomTitleButton(
                    icon: Iconsax.medal_star5,
                    label: 'Finish Workout',
                    onTap: () {
                      final sessionWithDuration = session.copyWith(durationInSeconds: _seconds, date: DateTime.now());
                      context.read<WorkoutCubit>().saveWorkoutSession(sessionWithDuration);

                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const TotalWorkoutTimeCounter()));
                    },
                  ),
                )
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
                Text(TextUtil.formatTimeToDigitalFormat(_seconds), style: boldLargeBlack),
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

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }
}
