import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/colored_safe_area_body.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_button.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/journal/components/widgets/body_part_piechart.dart';
import 'package:training_partner/features/journal/components/widgets/journal_exercise_card.dart';
import 'package:training_partner/features/journal/components/widgets/progress_bar_chart.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class JournalEntryPage extends StatefulWidget {
  final WorkoutSession currentSession;
  final WorkoutSession? previousSession;
  final List<Movement> movements;
  final PageController pageController;
  final AppSettings settings;

  const JournalEntryPage({
    super.key,
    required this.currentSession,
    this.previousSession,
    required this.movements,
    required this.pageController,
    required this.settings,
  });

  @override
  State<JournalEntryPage> createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  WorkoutSession get currentSession => widget.currentSession;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ColoredSafeAreaBody(
        safeAreaColor: Theme.of(context).cardColor,
        isLightTheme: Theme.of(context).brightness == Brightness.light,
        child: Column(
          children: [
            _getBodyContent(),
          ],
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _getHeaderWidget(),
            Padding(
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
          ],
        ),
      ),
    );
  }

  Widget _getHeaderWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
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
                CustomBackButton(context: context),
                Text(currentSession.name, style: CustomTextStyle.titlePrimary(context)),
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
            Row(
              children: [
                const Icon(FontAwesomeIcons.circleInfo, size: 20),
                const SizedBox(width: 10),
                Text('Information:', style: CustomTextStyle.subtitlePrimary(context)),
              ],
            ),
            const SizedBox(height: 10),
            CustomDivider(color: Theme.of(context).colorScheme.secondary),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(children: [
                      Icon(Iconsax.clock5, color: Theme.of(context).colorScheme.secondary, size: 20),
                      const SizedBox(width: 10),
                      Text('Duration:', style: CustomTextStyle.bodySecondary(context)),
                    ]),
                    const Spacer(),
                    Text(DateTimeUtil.secondsToTextTime(currentSession.durationInSeconds!), style: CustomTextStyle.bodySecondary(context)),
                  ],
                ),
                Row(
                  children: [
                    Row(children: [
                      Icon(Iconsax.calendar5, color: Theme.of(context).colorScheme.secondary, size: 20),
                      const SizedBox(width: 10),
                      Text('Date:', style: CustomTextStyle.bodySecondary(context)),
                    ]),
                    const Spacer(),
                    Text(DateTimeUtil.dateToStringWithHour(currentSession.date!, widget.settings.is24HourFormat),
                        style: CustomTextStyle.bodySecondary(context)),
                  ],
                ),
                Row(
                  children: [
                    Row(children: [
                      Icon(FontAwesomeIcons.dumbbell, color: Theme.of(context).colorScheme.secondary, size: 15),
                      const SizedBox(width: 15),
                      Text('Total exercises:', style: CustomTextStyle.bodySecondary(context)),
                    ]),
                    const Spacer(),
                    Text('${currentSession.exercises.length} exercises', style: CustomTextStyle.bodySecondary(context)),
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
            Row(
              children: [
                const Icon(FontAwesomeIcons.chartPie, size: 20),
                const SizedBox(width: 10),
                Text('Targeted muscles:', style: CustomTextStyle.subtitlePrimary(context)),
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
                Row(
                  children: [
                    const Icon(FontAwesomeIcons.arrowTrendUp, size: 20),
                    const SizedBox(width: 10),
                    Text('Progress from last session:', style: CustomTextStyle.subtitlePrimary(context)),
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
      Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(FontAwesomeIcons.personRunning),
                  const SizedBox(width: 10),
                  Text('Exercises:', style: CustomTextStyle.subtitlePrimary(context)),
                ],
              ),
              const SizedBox(height: 10),
              CustomDivider(color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 10),
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
          settings: widget.settings,
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
              Row(
                children: [
                  const Icon(Icons.warning_rounded),
                  const SizedBox(width: 5),
                  Text('Warning', style: CustomTextStyle.subtitlePrimary(context)),
                ],
              ),
              Text('Are you sure you want to delete this workout session?', style: CustomTextStyle.bodySecondary(context)),
              const SizedBox(height: 15),
              Row(
                children: [
                  CustomButton(
                    label: 'No',
                    isSecondary: true,
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
