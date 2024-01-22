import 'package:flutter/material.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_small_button.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/workout/components/pages/workout_editor_page.dart';
import 'package:training_partner/features/workout/models/workout_plan.dart';

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
            print('Delete workoutplan');
          },
        ),
      ],
      child: const CustomSmallButton(
        icon: Icon(Icons.more_horiz),
        padding: EdgeInsets.only(left: 10, right: 5),
      ),
    );
  }
}
