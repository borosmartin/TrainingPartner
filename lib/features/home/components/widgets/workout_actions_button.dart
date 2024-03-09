import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout_editor/components/pages/workout_editor_page.dart';
import 'package:training_partner/features/workout_editor/logic/cubits/workout_plan_cubit.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class WorkoutPlanActionsButton extends StatelessWidget {
  final WorkoutPlan? workoutPlan;
  final List<Movement> movements;

  const WorkoutPlanActionsButton({super.key, this.workoutPlan, required this.movements});

  @override
  Widget build(BuildContext context) {
    return QudsPopupButton(
      backgroundColor: Colors.white,
      items: [
        QudsPopupMenuItem(
          leading: const Icon(Iconsax.note_215, color: Colors.green, size: 30),
          title: Text(
            'New workoutplan',
            style: TextUtil.getCustomTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkoutEditorPage(movements: movements),
            ),
          ),
        ),
        QudsPopupMenuItem(
          leading: const Icon(Iconsax.edit_25),
          title: const Text('Edit workoutplan', style: normalBlack),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkoutEditorPage(workoutPlan: workoutPlan, movements: movements),
            ),
          ),
        ),
        QudsPopupMenuItem(
          leading: const Icon(Iconsax.trash4, color: Colors.red),
          title: Text(
            'Delete workoutplan',
            style: TextUtil.getCustomTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          onPressed: () {
            context.read<WorkoutPlanCubit>().deleteWorkoutPlan(workoutPlan!);
          },
        ),
      ],
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.tertiary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
          ),
        ),
        margin: EdgeInsets.zero,
        child: const SizedBox(
          width: 60,
          height: 60,
          child: Icon(
            Icons.more_horiz_rounded,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
