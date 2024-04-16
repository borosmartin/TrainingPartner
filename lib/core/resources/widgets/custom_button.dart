import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Function() onTap;
  final bool? isEnabled;
  final bool? isSecondary;

  const CustomButton({
    this.icon,
    required this.label,
    required this.onTap,
    this.isEnabled = true,
    this.isSecondary = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: isSecondary!
          ? ElevatedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              alignment: Alignment.center,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: defaultCornerShape,
            )
          : ElevatedButton.styleFrom(
              alignment: Alignment.center,
              elevation: 0,
              backgroundColor: accentColor,
              shape: defaultCornerShape,
            ),
      onPressed: isEnabled! ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon, color: Colors.white, size: 30),
            if (icon != null) const SizedBox(width: 10),
            Text(label, style: CustomTextStyle.subtitleTetriary(context)),
          ],
        ),
      ),
    );
  }
}
