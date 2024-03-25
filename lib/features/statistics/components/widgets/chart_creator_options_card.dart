import 'package:flutter/material.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class ChartCreatorOptionsCard extends StatelessWidget {
  final String title;
  final String value;
  final Icon icon;
  final List<QudsPopupMenuItem> options;
  final Function? onTap;

  const ChartCreatorOptionsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.options,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: defaultBorderRadius,
        onTap: () => onTap != null
            ? onTap!()
            : showQudsPopupMenu(
                context: context,
                items: options,
                startOffset: const Offset(1, 0),
                backgroundColor: Colors.white,
              ),
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
                  const SizedBox(width: 10),
                  Text(title, style: boldNormalGrey),
                ],
              ),
              Text(value, style: boldNormalGrey, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
