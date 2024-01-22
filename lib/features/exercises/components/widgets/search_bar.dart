import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class SearchBar2 extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  const SearchBar2({required this.textController, required this.hintText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onChanged: (value) {},
      cursorColor: Theme.of(context).colorScheme.tertiary,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
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
