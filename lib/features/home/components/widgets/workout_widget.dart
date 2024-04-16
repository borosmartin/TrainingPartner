import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/home/components/widgets/workout_start_bottom_sheet.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/workout_editor/components/pages/workout_editor_page.dart';
import 'package:training_partner/features/workout_editor/logic/cubits/workout_plan_cubit.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';
import 'package:training_partner/generated/assets.dart';

class WorkoutWidget extends StatefulWidget {
  final List<WorkoutPlan>? workoutPlans;
  final List<WorkoutSession> previousSessions;
  final WorkoutPlan? selectedWorkoutPlan;
  final void Function(WorkoutPlan) onSelect;
  final List<Movement> movements;
  final AppSettings settings;

  const WorkoutWidget({
    Key? key,
    required this.workoutPlans,
    required this.previousSessions,
    required this.selectedWorkoutPlan,
    required this.onSelect,
    required this.movements,
    required this.settings,
  }) : super(key: key);

  @override
  State<WorkoutWidget> createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  WorkoutPlan? _selectedWorkoutPlan;

  @override
  void initState() {
    super.initState();

    if (widget.selectedWorkoutPlan != null) {
      _selectedWorkoutPlan = widget.selectedWorkoutPlan;
    } else if (widget.workoutPlans != null && widget.workoutPlans!.isNotEmpty) {
      _selectedWorkoutPlan = widget.workoutPlans!.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.workoutPlans == null || widget.workoutPlans!.isEmpty || _selectedWorkoutPlan == null) {
      return Column(
        children: [
          DividerWithText(text: 'Workout plan', textStyle: CustomTextStyle.bodySecondary(context)),
          const SizedBox(height: 15),
          const Icon(Iconsax.note_215, size: 85, color: Colors.black38),
          Text('No workout plans yet, create a new one!', style: CustomTextStyle.subtitleSecondary(context)),
          const SizedBox(height: 20),
          CustomTitleButton(
            label: 'Create',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WorkoutEditorPage(
                  movements: widget.movements,
                  settings: widget.settings,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 7.5),
          child: Row(
            children: [
              Text('Workoutplans', style: CustomTextStyle.subtitlePrimary(context)),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WorkoutEditorPage(movements: widget.movements, settings: widget.settings),
                  ),
                ),
                icon: const PhosphorIcon(
                  PhosphorIconsBold.plus,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        WorkoutEditorPage(workoutPlan: widget.selectedWorkoutPlan, movements: widget.movements, settings: widget.settings),
                  ),
                ),
                icon: const PhosphorIcon(
                  PhosphorIconsBold.pencilSimple,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<WorkoutPlanCubit>().deleteWorkoutPlan(widget.selectedWorkoutPlan!);
                },
                icon: const PhosphorIcon(
                  PhosphorIconsBold.trash,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        _getWorkoutPlansWidget(),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.only(left: 7.5),
          child: Text('Workout sessions', style: CustomTextStyle.subtitlePrimary(context)),
        ),
        const SizedBox(height: 5),
        _getSessionRows(context),
      ],
    );
  }

  Widget _getWorkoutPlansWidget() {
    List<Widget> plans = [];

    for (int i = 0; i < widget.workoutPlans!.length; i++) {
      plans.add(_getWorkoutPlanCard(widget.workoutPlans![i], i));
    }

    return SizedBox(
      height: 255,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: plans,
        ),
      ),
    );
  }

  Widget _getWorkoutPlanCard(WorkoutPlan workoutPlan, int index) {
    var images = [
      Assets.imagesWorkoutplan1,
      Assets.imagesWorkoutplan2,
      Assets.imagesWorkoutplan3,
      Assets.imagesWorkoutplan4,
      Assets.imagesWorkoutplan5
    ];

    bool isSelected = _selectedWorkoutPlan == workoutPlan;

    return GestureDetector(
      onTap: () {
        widget.onSelect(workoutPlan);
        setState(() {
          _selectedWorkoutPlan = workoutPlan;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Card(
          elevation: 0,
          color: isSelected ? accentColor : Theme.of(context).cardColor,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(7.5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    images[index],
                    height: 175,
                    width: 175,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(PhosphorIconsFill.barbell, size: 17, color: isSelected ? Colors.white : null),
                      const SizedBox(width: 5),
                      Text(
                        workoutPlan.name,
                        style: isSelected ? CustomTextStyle.bodyTetriary(context) : CustomTextStyle.bodyPrimary(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Iconsax.flash_15, size: 17, color: isSelected ? Colors.white : Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 5),
                      Text(
                        '${workoutPlan.sessions.length} sessions',
                        style: isSelected ? CustomTextStyle.bodySmallTetriary(context) : CustomTextStyle.bodySmallSecondary(context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSessionRows(BuildContext context) {
    List<WorkoutSession> sessions = _selectedWorkoutPlan!.sessions;

    List<Widget> sessionRows = [];
    for (int i = 0; i < sessions.length; i++) {
      sessionRows.add(buildSessionRow(context, i, sessions[i], sessions));
    }

    return Column(
      children: sessionRows,
    );
  }

  Widget buildSessionRow(BuildContext context, int index, WorkoutSession session, List<WorkoutSession> sessions) {
    bool isLast = index == sessions.length - 1;
    bool isFirst = index == 0;
    int setNum = 0;

    for (var set in session.exercises) {
      setNum += set.workoutSets.length;
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: isLast
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            )
          : isFirst
              ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                )
              : const RoundedRectangleBorder(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : isFirst
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    )
                  : BorderRadius.zero,
          onTap: () => _showWorkoutStartBottomSheet(context, session),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5, right: 15, left: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    child: Center(
                      child: Text((index + 1).toString(), style: CustomTextStyle.titlePrimary(context)),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CustomDivider(isVertical: true, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(session.name, style: CustomTextStyle.bodyPrimary(context)),
                      Text('${session.exercises.length} exercise  -  $setNum sets', style: CustomTextStyle.bodySmallSecondary(context)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(PhosphorIconsBold.playCircle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showWorkoutStartBottomSheet(BuildContext context, WorkoutSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return WorkoutStartBottomSheet(
          session: session,
          previousSessions: widget.previousSessions,
          workoutPlanName: _selectedWorkoutPlan!.name,
          movements: widget.movements,
          settings: widget.settings,
        );
      },
    );
  }
}
