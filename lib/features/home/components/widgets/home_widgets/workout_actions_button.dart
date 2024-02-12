import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/home/components/pages/workout_editor_page.dart';
import 'package:training_partner/features/home/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';

class WorkoutPlanActionsButton extends StatelessWidget {
  final WorkoutPlan? workoutPlan;
  const WorkoutPlanActionsButton({super.key, this.workoutPlan});

  @override
  Widget build(BuildContext context) {
    return QudsPopupButton(
      // todo colors
      backgroundColor: Colors.white,
      items: [
        QudsPopupMenuItem(
          leading: Icon(Icons.add_rounded, color: Colors.grey.shade800),
          title: const Text('New workoutplan', style: normalGrey),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const WorkoutEditorPage(),
            ),
          ),
        ),
        QudsPopupMenuItem(
          leading: Icon(Icons.edit_rounded, color: Colors.grey.shade800),
          title: const Text('Edit workoutplan', style: normalGrey),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WorkoutEditorPage(workoutPlan: workoutPlan),
            ),
          ),
        ),
        QudsPopupMenuItem(
          leading: const Icon(Icons.delete_rounded, color: Colors.red),
          title: Text('Delete workoutplan', style: TextUtil.getCustomTextStyle(color: Colors.red)),
          onPressed: () {
            context.read<WorkoutCubit>().deleteWorkoutPlan(workoutPlan!);
          },
        ),
      ],
      child: const Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        margin: EdgeInsets.zero,
        child: SizedBox(
          height: 66,
          width: 66,
          child: Icon(
            Icons.more_horiz_rounded,
            size: 25,
          ),
        ),
      ),
    );
  }
}
