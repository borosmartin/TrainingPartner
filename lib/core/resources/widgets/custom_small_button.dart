import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomSmallButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final String? label;
  final double? elevation;
  final Color? backgroundColor;

  const CustomSmallButton({
    super.key,
    required this.icon,
    this.onTap,
    this.padding,
    this.label,
    this.elevation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: padding ?? EdgeInsets.zero,
      elevation: elevation ?? 0,
      color: backgroundColor ?? Colors.white,
      shape: defaultCornerShape,
      child: InkWell(
        onTap: onTap,
        borderRadius: defaultBorderRadius,
        child: SizedBox(
          height: 60,
          width: label != null ? null : 60,
          child: Padding(
            padding: label != null ? const EdgeInsets.all(10) : EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                if (label != null) const SizedBox(width: 10),
                if (label != null) Text(label!, style: CustomTextStyle.bodyPrimary(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
