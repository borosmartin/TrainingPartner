import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_back_button.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/selectable_movement_card.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class SessionWidget extends StatelessWidget {
  final WorkoutSession session;
  final List<Movement> movements;
  final void Function(String) onRename;

  const SessionWidget({
    super.key,
    required this.session,
    required this.onRename,
    required this.movements,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // TITLE
                      GestureDetector(
                        onTap: () => _showRenameDialog(context),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.edit, color: Colors.black45, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  session.name,
                                  style: boldLargeGrey,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.list_alt_rounded,
                            color: Theme.of(context).colorScheme.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text('${session.exercises.length} exercises', style: smallGrey),
                          const SizedBox(width: 10),
                          Text('${session.exercises.length} sets', style: smallGrey),
                        ],
                      ),
                    ],
                  ),
                ),

                // EXERCISE BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    shape: defaultCornerShape,
                    elevation: 0,
                    padding: const EdgeInsets.all(13),
                  ),
                  onPressed: () => _showExerciseBottomSheet(context),
                  child: const Row(
                    children: [
                      Icon(Icons.fitness_center, size: 26, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Exercises', style: boldNormalWhite),
                    ],
                  ),
                ),
              ],
            ),
            _getExerciseList(session),
          ],
        ),
      ),
    );
  }

  Widget _getExerciseList(WorkoutSession session) {
    if (session.exercises.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 200),
          //todo icon
          Icon(Icons.accessibility_rounded, size: 80, color: Colors.black38),
          Text('No exercises yet, add a few!', style: boldNormalGrey),
        ],
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: session.exercises.length,
          itemBuilder: (context, index) {
            return Text(session.exercises[index].movement.name);
          },
        ),
      );
    }
  }

  void _showRenameDialog(BuildContext context) {
    String newName = '';
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Dialog(
            elevation: 0,
            shape: defaultCornerShape,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.drive_file_rename_outline_outlined),
                      SizedBox(width: 10),
                      Text('Rename session', style: boldNormalBlack),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    onChanged: (value) {
                      newName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'New name',
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      fillColor: Theme.of(context).colorScheme.primary,
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
                  ),
                  const SizedBox(height: 20),
                  CustomTitleButton(
                    label: 'Rename',
                    onTap: () {
                      if (newName.isNotEmpty) {
                        onRename(newName);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showExerciseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 0,
                        color: Colors.black26,
                        child: SizedBox(
                          height: 5,
                          width: 80,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomBackButton(color: Colors.black38),
                      const Text('Exercises', style: boldLargeBlack),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_alt_rounded,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: movements.length,
                      itemBuilder: (context, index) {
                        return SelectableMovementCard(
                          movement: movements[index],
                          onSelectChanged: (isSelected) {},
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTitleButton(
                    label: 'Add selected ',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
