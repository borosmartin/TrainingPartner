import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/workout/components/widgets/workout_rename_dialog.dart';
import 'package:training_partner/features/workout/models/workout_plan.dart';

class WorkoutEditorPage extends StatefulWidget {
  final WorkoutPlan? workoutPlan;

  const WorkoutEditorPage({
    super.key,
    this.workoutPlan,
  });

  @override
  State<WorkoutEditorPage> createState() => _WorkoutEditorPageState();
}

class _WorkoutEditorPageState extends State<WorkoutEditorPage> {
  WorkoutPlan? workoutPlan;
  late String workoutName;
  late bool doesPlanExist;

  @override
  void initState() {
    super.initState();

    workoutPlan = widget.workoutPlan;
    doesPlanExist = workoutPlan != null;

    if (doesPlanExist) {
      workoutName = workoutPlan!.name;
    } else {
      workoutName = 'My workoutplan';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return PopScope(
      onPopInvoked: (value) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.background,
          statusBarIconBrightness: Brightness.dark,
        ));
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: _getBodyContent(),
          ),
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Cancel', style: boldNormalGrey),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => WorkoutNameDialog(onRename: (name) {
                              setState(() {
                                workoutName = name;
                              });
                            }));
                  },
                  child: Row(
                    children: [
                      Text(workoutName, style: boldLargeBlack),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Text('Save', style: boldNormalAccent),
              ],
            ),
          ),
        ),
        Expanded(child: ListView(children: [])),
      ],
    );
  }
}
