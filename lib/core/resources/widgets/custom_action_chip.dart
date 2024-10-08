import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';

class CustomActionChip extends StatefulWidget {
  final String label;
  final Function(bool, String) onTap;
  final bool? isSelected;
  final Color unSelectedColor;

  const CustomActionChip({
    super.key,
    required this.label,
    required this.onTap,
    this.isSelected,
    required this.unSelectedColor,
  });

  @override
  State<CustomActionChip> createState() => _CustomActionChipState();
}

class _CustomActionChipState extends State<CustomActionChip> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });

        widget.onTap(isSelected, widget.label);
      },
      child: Card(
        elevation: 0,
        shape: defaultCornerShape,
        color: isSelected ? accentColor : widget.unSelectedColor,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(TextUtil.firstLetterToUpperCase(widget.label),
              style: isSelected ? CustomTextStyle.bodySmallTetriary(context) : CustomTextStyle.bodySmallSecondary(context)),
        ),
      ),
    );
  }
}
