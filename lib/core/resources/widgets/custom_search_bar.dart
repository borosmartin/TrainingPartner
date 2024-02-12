import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final Color? iconColor;
  final TextStyle? hintStyle;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Function(String) onChanged;

  const CustomSearchBar({
    Key? key,
    required this.textController,
    required this.hintText,
    required this.onChanged,
    this.iconColor,
    this.backgroundColor,
    this.textStyle,
    this.hintStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onChanged: onChanged,
      style: textStyle ?? smallGrey,
      cursorColor: Theme.of(context).colorScheme.tertiary,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: iconColor ?? Colors.black45),
        suffixIcon: textController.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  textController.clear();
                  onChanged('');
                },
                child: Icon(Icons.clear, color: iconColor ?? Colors.black45),
              )
            : null,
        filled: true,
        fillColor: backgroundColor ?? Colors.grey.shade200,
        hintText: hintText,
        hintStyle: hintStyle ?? smallGrey,
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: defaultBorderRadius,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: defaultBorderRadius,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: defaultBorderRadius,
        ),
      ),
    );
  }
}
