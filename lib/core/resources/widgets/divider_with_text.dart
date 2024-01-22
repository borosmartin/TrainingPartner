import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  const DividerWithText({super.key, required this.text, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: CustomDivider(
            thickness: 2.0,
            padding: EdgeInsets.only(right: 20),
          ),
        ),
        Text(
          text,
          style: textStyle,
        ),
        const Expanded(
          child: CustomDivider(
            thickness: 2.0,
            padding: EdgeInsets.only(left: 20),
          ),
        ),
      ],
    );
  }
}
