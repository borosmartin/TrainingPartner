import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final Function(String) onChanged;
  const CustomSearchBar({
    Key? key,
    required this.textController,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onChanged: onChanged,
      style: smallGrey,
      cursorColor: Theme.of(context).colorScheme.tertiary,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black45),
        suffixIcon: textController.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  textController.clear();
                  onChanged('');
                },
                child: const Icon(Icons.clear, color: Colors.black45),
              )
            : null,
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hintText,
        hintStyle: smallGrey,
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
