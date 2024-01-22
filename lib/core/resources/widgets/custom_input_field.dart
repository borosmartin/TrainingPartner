import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final String labelText;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final Widget? trailing;
  final FocusNode? focusNode;
  const CustomInputField({
    Key? key,
    required this.inputController,
    required this.hintText,
    required this.labelText,
    this.obscureText,
    this.keyboardType,
    this.trailing,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      keyboardType: keyboardType,
      style: normalBlack,
      cursorColor: Theme.of(context).colorScheme.tertiary,
      obscureText: obscureText ?? false,
      focusNode: focusNode,
      decoration: InputDecoration(
        label: Text(labelText, style: normalBlack),
        filled: true,
        suffixIcon: trailing,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        fillColor: Theme.of(context).colorScheme.primary,
        hintText: hintText,
        hintStyle: smallGrey,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: defaultBorderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 2),
          borderRadius: defaultBorderRadius,
        ),
      ),
    );
  }
}
