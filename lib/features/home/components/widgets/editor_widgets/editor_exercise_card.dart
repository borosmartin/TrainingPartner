import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_detail_page.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/home/components/widgets/editor_widgets/editor_wheel_dialog.dart';

class EditorExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final List<Exercise> exerciseList;
  final bool isFirst;
  final bool isLast;
  final Function(int, int) onSetValuesChange;
  final VoidCallback onRemoveExercise;
  final VoidCallback onChangeType;

  const EditorExerciseCard({
    super.key,
    required this.exercise,
    required this.exerciseList,
    required this.onSetValuesChange,
    required this.isFirst,
    required this.isLast,
    required this.onRemoveExercise,
    required this.onChangeType,
  });

  @override
  State<EditorExerciseCard> createState() => _EditorExerciseCardState();
}

class _EditorExerciseCardState extends State<EditorExerciseCard> {
  late TextEditingController firstController;
  late TextEditingController secondController;

  @override
  void initState() {
    super.initState();

    firstController = TextEditingController();
    secondController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isFirst && widget.isLast
          ? const BoxDecoration(color: Colors.white, borderRadius: defaultBorderRadius)
          : widget.isFirst
              ? const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ))
              : widget.isLast
                  ? const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ))
                  : const BoxDecoration(
                      color: Colors.white,
                    ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.exercise.movement.gifUrl,
                    height: 100,
                    width: 100,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                        borderRadius: defaultBorderRadius,
                      ),
                    ),
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: ShimmerContainer(height: 100, width: 100),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.exercise.movement.name, style: boldNormalBlack),
                                  Text(TextUtil.firstLetterToUpperCase(widget.exercise.movement.equipment), style: normalGrey),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                            _getExerciseOptions(),
                          ],
                        ),
                        const SizedBox(height: 5),
                        _getSetNumRow(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getSetNumRow() {
    return Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      color: Colors.grey.shade200,
      child: InkWell(
        borderRadius: defaultBorderRadius,
        onTap: () => _showWheelNumberDialog(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // todo: nem egyésges a padding ezzel a megoldással
                Expanded(
                  child: Center(
                    child: Text(_getFirstValue(true), style: smallGrey),
                  ),
                ),
                const VerticalDivider(
                  width: 0,
                  thickness: 2,
                  color: Colors.black26,
                  indent: 2,
                  endIndent: 2,
                ),
                Expanded(
                  child: Center(
                    child: Text(_getSecondValue(true), style: smallGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWheelNumberDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditorWheelDialog(
          firstValue: _getFirstValue(false),
          secondValue: _getSecondValue(false),
          exerciseType: widget.exercise.type,
          onSetValuesChange: widget.onSetValuesChange,
        );
      },
    );
  }

  dynamic _getFirstValue(bool isString) {
    Exercise exercise = widget.exercise;

    if (exercise.type == ExerciseType.setRep) {
      if (exercise.workoutSets.isNotEmpty) {
        return isString ? '${widget.exercise.workoutSets.length}  Set' : widget.exercise.workoutSets.length;
      } else {
        return isString ? 'Set' : 0;
      }
    } else {
      if (exercise.workoutSets.firstOrNull != null &&
          exercise.workoutSets.isNotEmpty &&
          exercise.workoutSets.first.distance != null &&
          exercise.workoutSets.first.distance != 0) {
        return isString ? '${widget.exercise.workoutSets.first.distance}  m' : widget.exercise.workoutSets.first.distance;
      } else {
        return isString ? 'Distance' : 0;
      }
    }
  }

  dynamic _getSecondValue(bool isString) {
    Exercise exercise = widget.exercise;

    if (exercise.type == ExerciseType.setRep) {
      if (exercise.workoutSets.isNotEmpty &&
          exercise.workoutSets.firstOrNull != null &&
          exercise.workoutSets.first.repetitions != null &&
          exercise.workoutSets.first.repetitions != 0) {
        return isString ? '${exercise.workoutSets.first.repetitions}  Rep' : exercise.workoutSets.first.repetitions;
      } else {
        return isString ? 'Rep' : 0;
      }
    } else {
      if (exercise.workoutSets.firstOrNull != null &&
          exercise.workoutSets.isNotEmpty &&
          exercise.workoutSets.first.duration != null &&
          exercise.workoutSets.first.duration != 0) {
        return isString ? '${exercise.workoutSets.first.duration}  min' : exercise.workoutSets.first.duration;
      } else {
        return isString ? 'Distance' : 0;
      }
    }
  }

  // todo icons
  Widget _getExerciseOptions() {
    return QudsPopupButton(
      backgroundColor: Colors.white,
      items: [
        QudsPopupMenuItem(
          leading: const Icon(Iconsax.edit_25),
          title: const Text('Change type', style: normalBlack),
          onPressed: () => widget.onChangeType(),
        ),
        QudsPopupMenuItem(
          leading: const Icon(Icons.help_center_rounded, color: Colors.black38),
          title: const Text('About exercise', style: normalGrey),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExerciseDetailPage(movement: widget.exercise.movement),
            ),
          ),
        ),
        QudsPopupMenuItem(
          leading: const Icon(Icons.delete, color: Colors.red),
          title: Text(
            'Remove exercise',
            style: TextUtil.getCustomTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          onPressed: () {
            widget.onRemoveExercise();
            setState(() {});
          },
        ),
      ],
      child: const Icon(
        Icons.more_vert_rounded,
        size: 25,
        color: Colors.black38,
      ),
    );
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();

    super.dispose();
  }
}
