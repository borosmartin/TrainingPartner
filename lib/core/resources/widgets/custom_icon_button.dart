import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomIconButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;

  const CustomIconButton({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: defaultBorderRadius,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 25,
        ),
      ),
    );
  }
}
