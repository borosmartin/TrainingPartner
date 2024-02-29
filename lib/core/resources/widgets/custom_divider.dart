import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final bool isVertical;
  final double? thickness;
  final double? height;
  final Color? color;
  final double? indents;

  const CustomDivider({
    super.key,
    this.padding,
    this.thickness,
    this.isVertical = false,
    this.height,
    this.color,
    this.indents,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: isVertical
          ? VerticalDivider(
              width: 0,
              thickness: thickness ?? 1.5,
              color: color ?? Colors.grey.shade300,
              indent: indents ?? 5,
              endIndent: indents ?? 5,
            )
          : Divider(
              height: 0,
              thickness: thickness ?? 1.5,
              color: color ?? Colors.grey.shade300,
            ),
    );
  }
}
