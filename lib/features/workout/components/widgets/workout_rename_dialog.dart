import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_dialog.dart';
import 'package:training_partner/core/resources/widgets/custom_input_field.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';

class WorkoutNameDialog extends StatefulWidget {
  final Function(String) onRename;

  const WorkoutNameDialog({super.key, required this.onRename});

  @override
  State<WorkoutNameDialog> createState() => _WorkoutNameDialogState();
}

class _WorkoutNameDialogState extends State<WorkoutNameDialog> {
  final TextEditingController _workoutNameController = TextEditingController();
  FToast toast = FToast();

  @override
  void initState() {
    super.initState();

    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Rename your workoutplan', style: boldNormalBlack),
          const Text('Please enter your desired name bellow.', style: smallGrey),
          const SizedBox(height: 20),
          CustomInputField(
            labelText: 'Name',
            inputController: _workoutNameController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'My workoutplan',
          ),
          const SizedBox(height: 20),
          CustomTitleButton(
            label: 'Rename',
            onTap: _handleRename,
          ),
        ],
      ),
    );
  }

  void _handleRename() {
    if (_workoutNameController.text.isEmpty) {
      showErrorToast(toast, 'Please enter a name!');
    } else {
      widget.onRename(_workoutNameController.text);
      Navigator.pop(context);
    }
  }
}
