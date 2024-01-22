import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/exercises/components/widgets/search_bar.dart';

class ExerciseHeader extends StatefulWidget {
  final String groupName;
  final String assetLocation;
  const ExerciseHeader({super.key, required this.groupName, required this.assetLocation});

  @override
  State<ExerciseHeader> createState() => _ExerciseHeaderState();
}

class _ExerciseHeaderState extends State<ExerciseHeader> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                Image.asset(widget.assetLocation, height: 60, width: 60),
                const SizedBox(width: 20),
                Text(widget.groupName, style: boldNormalBlack),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SearchBar2(textController: textController, hintText: 'Search...'),
            )
          ],
        ),
      ),
    );
  }
}
