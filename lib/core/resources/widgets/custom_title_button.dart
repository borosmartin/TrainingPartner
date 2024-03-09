import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomTitleButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Function()? onPressed;
  final bool? isEnabled;

  const CustomTitleButton({
    this.icon,
    required this.label,
    this.onPressed,
    this.isEnabled = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        elevation: 0,
        minimumSize: const Size.fromHeight(60),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        shape: defaultCornerShape,
      ),
      onPressed: isEnabled! ? onPressed : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: Colors.white, size: 30),
          if (icon != null) const SizedBox(width: 10),
          Text(label, style: boldLargeWhite),
        ],
      ),
    );
  }
}
