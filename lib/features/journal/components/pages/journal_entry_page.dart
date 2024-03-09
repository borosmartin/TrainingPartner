import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_button.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/journal/components/widgets/body_part_piechart.dart';
import 'package:training_partner/features/journal/components/widgets/journal_exercise_card.dart';
import 'package:training_partner/features/journal/components/widgets/progress_bar_chart.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class JournalEntryPage extends StatefulWidget {
  final WorkoutSession currentSession;
  final WorkoutSession? previousSession;
  final List<Movement> movements;
  final PageController pageController;

  const JournalEntryPage({
    super.key,
    required this.currentSession,
    this.previousSession,
    required this.movements,
    required this.pageController,
  });

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  WorkoutSession get currentSession => widget.currentSession;

  @override
  void initState() {
    super.initState();

    colorSafeArea(color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) => colorSafeArea(color: Theme.of(context).colorScheme.background),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [
              _getHeaderWidget(),
              _getBodyContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 15),
              _getInfoCard(),
              const SizedBox(height: 15),
              _getBodyPartsPieCard(),
              const SizedBox(height: 15),
              _getProgressBarCard(),
              _getExerciseCardList(),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
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
                const CustomBackButton(),
                Text(currentSession.name, style: boldLargeBlack),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: GestureDetector(
                    onTap: _showDeleteDialog,
                    child: const Icon(FontAwesomeIcons.trash, color: Colors.red, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getInfoCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(FontAwesomeIcons.circleInfo, size: 20),
                SizedBox(width: 10),
                Text('Information:', style: boldNormalBlack),
              ],
            ),
            const SizedBox(height: 10),
            const CustomDivider(),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Row(children: [
                      Icon(Iconsax.clock5, color: Colors.black38, size: 20),
                      SizedBox(width: 10),
                      Text('Duration:', style: normalGrey),
                    ]),
                    const Spacer(),
                    Text(DateTimeUtil.secondsToTextTime(currentSession.durationInSeconds!), style: normalGrey),
                  ],
                ),
                Row(
                  children: [
                    const Row(children: [
                      Icon(Iconsax.calendar5, color: Colors.black38, size: 20),
                      SizedBox(width: 10),
                      Text('Date:', style: normalGrey),
                    ]),
                    const Spacer(),
                    Text(DateTimeUtil.dateToStringWithHour(currentSession.date!), style: normalGrey),
                  ],
                ),
                Row(
                  children: [
                    const Row(children: [
                      Icon(FontAwesomeIcons.dumbbell, color: Colors.black38, size: 15),
                      SizedBox(width: 15),
                      Text('Total exercises:', style: normalGrey),
                    ]),
                    const Spacer(),
                    Text('${currentSession.exercises.length} exercises', style: normalGrey),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBodyPartsPieCard() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(FontAwesomeIcons.chartPie, size: 20),
                SizedBox(width: 10),
                Text('Targeted muscles:', style: boldNormalBlack),
              ],
            ),
            const SizedBox(height: 20),
            BodyPartPieChart(bodyPartMap: _countSetsByBodyPart()),
          ],
        ),
      ),
    );
  }

  Widget _getProgressBarCard() {
    bool containtsReps = false;
    for (var exercise in currentSession.exercises) {
      if (exercise.type == ExerciseType.repetitions) {
        containtsReps = true;
      }
    }

    if (widget.previousSession == null || !containtsReps) {
      return Container();
    }

    return Column(
      children: [
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: defaultCornerShape,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(FontAwesomeIcons.arrowTrendUp, size: 20),
                    SizedBox(width: 10),
                    Text('Progress from last session:', style: boldNormalBlack),
                  ],
                ),
                const SizedBox(height: 20),
                ProgressBarChart(currentSession: currentSession, previousSession: widget.previousSession!),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _getExerciseCardList() {
    List<Widget> children = [];
    children.add(
      const Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.personRunning),
                  SizedBox(width: 10),
                  Text('Exercises:', style: boldNormalBlack),
                ],
              ),
              SizedBox(height: 10),
              CustomDivider(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

    for (int i = 0; i < currentSession.exercises.length; i++) {
      children.add(
        JournalExerciseCard(
          exercise: currentSession.exercises[i],
          previousExercise: widget.previousSession?.exercises[i],
          isFirst: currentSession.exercises[i] == currentSession.exercises.first,
          isLast: currentSession.exercises[i] == currentSession.exercises.last,
          index: i,
          movements: widget.movements,
        ),
      );
    }

    return Column(children: children);
  }

  Map<String, int> _countSetsByBodyPart() {
    Map<String, int> bodyPartMap = {};

    for (var exercise in currentSession.exercises) {
      String bodyPart = exercise.movement.bodyPart;

      int sets = exercise.workoutSets.length;

      if (bodyPartMap.containsKey(bodyPart)) {
        bodyPartMap[bodyPart] = (bodyPartMap[bodyPart] ?? 0) + sets;
      } else {
        bodyPartMap[bodyPart] = sets;
      }
    }

    return bodyPartMap;
  }

  // todo kicsit szépíteni
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
              const Text('Are you sure you want to delete this workout session?', style: normalGrey),
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
                      context.read<WorkoutCubit>().deleteWorkoutSession(currentSession);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      widget.pageController.jumpToPage(2);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
