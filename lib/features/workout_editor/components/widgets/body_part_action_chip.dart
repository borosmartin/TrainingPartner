import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class BodyPartActionChip extends StatefulWidget {
  final String label;
  final String assetLocation;
  final Function(bool, String) onTap;
  final bool? isSelected;

  const BodyPartActionChip({
    super.key,
    required this.label,
    required this.onTap,
    required this.assetLocation,
    this.isSelected,
  });

  @override
  State<BodyPartActionChip> createState() => _BodyPartActionChipState();
}

class _BodyPartActionChipState extends State<BodyPartActionChip> {
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
        shape: RoundedRectangleBorder(
          borderRadius: defaultBorderRadius,
          side: BorderSide(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(widget.assetLocation, height: 50, width: 50),
          ),
        ),
      ),
    );
  }
}
