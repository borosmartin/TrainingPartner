import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class SettingsCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final Widget child;
  final bool isFirst;
  final bool isLast;

  const SettingsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: _getBorderShape(),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icon,
                const SizedBox(width: 15),
                Text(title, style: CustomTextStyle.subtitleSecondary(context)),
              ],
            ),
            child
          ],
        ),
      ),
    );
  }

  RoundedRectangleBorder _getBorderShape() {
    RoundedRectangleBorder shape = defaultCornerShape;

    if (isFirst && !isLast) {
      shape = const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)));
    } else if (isLast && !isFirst) {
      shape = const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)));
    } else if (isFirst && isLast) {
      shape = const RoundedRectangleBorder();
    }

    return shape;
  }
}
