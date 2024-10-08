import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout_editor/components/pages/exercise_picker_page.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class SessionHeader extends StatefulWidget {
  final WorkoutSession session;
  final List<Movement> allMovements;
  final void Function(String) onRename;
  final void Function(List<Exercise>) onExercisesChanged;

  const SessionHeader({
    super.key,
    required this.session,
    required this.onRename,
    required this.allMovements,
    required this.onExercisesChanged,
  });

  @override
  State<SessionHeader> createState() => _SessionHeaderState();
}

class _SessionHeaderState extends State<SessionHeader> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      Icon(Icons.edit,
                          color: Theme.of(context).brightness == Brightness.light ? primaryTextColors[0] : primaryTextColors[1], size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.session.name,
                          style: CustomTextStyle.titlePrimary(context),
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
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text('${widget.session.exercises.length} exercises', style: CustomTextStyle.bodySmallSecondary(context)),
                  const SizedBox(width: 10),
                  Text('${_getTotalSets()} sets', style: CustomTextStyle.bodySmallSecondary(context)),
                ],
              ),
            ],
          ),
        ),

        // EXERCISE BUTTON
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            shape: defaultCornerShape,
            elevation: 0,
            padding: const EdgeInsets.all(13),
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExercisePickerPage(
                session: widget.session,
                onExercisesChanged: widget.onExercisesChanged,
                allMovements: widget.allMovements,
                onRename: widget.onRename,
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(PhosphorIconsFill.barbell, size: 26, color: Colors.white),
              const SizedBox(width: 10),
              Text('Exercises', style: CustomTextStyle.subtitleTetriary(context)),
            ],
          ),
        ),
      ],
    );
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
                  Row(
                    children: [
                      const Icon(Icons.drive_file_rename_outline_outlined),
                      const SizedBox(width: 10),
                      Text('Rename session', style: CustomTextStyle.subtitlePrimary(context)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: textController,
                    autofocus: true,
                    style: CustomTextStyle.bodyPrimary(context),
                    onChanged: (value) {
                      newName = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'New name',
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      fillColor: Theme.of(context).colorScheme.primary,
                      hintStyle: CustomTextStyle.bodySmallTetriary(context),
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
                        widget.onRename(newName);
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

  int _getTotalSets() {
    var totalSets = 0;

    if (widget.session.exercises.isNotEmpty) {
      for (Exercise exercise in widget.session.exercises) {
        totalSets += exercise.workoutSets.length;
      }
    }

    return totalSets;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
