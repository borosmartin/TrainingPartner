import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';

class CustomActionChip extends StatefulWidget {
  final String label;
  final Function(bool, String) onTap;
  const CustomActionChip({super.key, required this.label, required this.onTap});

  @override
  State<CustomActionChip> createState() => _CustomActionChipState();
}

class _CustomActionChipState extends State<CustomActionChip> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });

        widget.onTap(isActive, widget.label);
      },
      child: Card(
        elevation: 0,
        shape: defaultCornerShape,
        color: isActive ? Theme.of(context).colorScheme.tertiary : Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(TextUtil.firstLetterToUpperCase(widget.label), style: isActive ? smallWhite : smallGrey),
        ),
      ),
    );
  }
}
