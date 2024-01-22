import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomDialog extends StatelessWidget {
  final Widget child;
  const CustomDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Dialog(
        elevation: 0,
        shape: defaultCornerShape,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}
