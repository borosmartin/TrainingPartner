import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double? thickness;
  const CustomDivider({super.key, this.padding, this.thickness});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Divider(
        height: 0,
        thickness: thickness ?? 1.5,
        color: Colors.grey.shade300,
      ),
    );
  }
}
