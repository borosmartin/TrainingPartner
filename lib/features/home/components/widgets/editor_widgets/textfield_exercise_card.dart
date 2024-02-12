import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:popover/popover.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/shimmer_container.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class TextfieldExerciseCard extends StatefulWidget {
  final int index;
  final Exercise exercise;
  final List<Exercise> exerciseList;
  final bool isFirst;
  final bool isLast;
  final Function(int, int) onTextfieldChange;
  final VoidCallback onRemoveExercise;
  final VoidCallback onChangeType;

  const TextfieldExerciseCard({
    super.key,
    required this.index,
    required this.exercise,
    required this.exerciseList,
    required this.onTextfieldChange,
    required this.isFirst,
    required this.isLast,
    required this.onRemoveExercise,
    required this.onChangeType,
  });

  @override
  State<TextfieldExerciseCard> createState() => _TextfieldExerciseCardState();
}

class _TextfieldExerciseCardState extends State<TextfieldExerciseCard> {
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
                            Builder(builder: (builderContext) {
                              return IconButton(
                                onPressed: () => showPopover(
                                  context: builderContext,
                                  bodyBuilder: (builderContext) => _getExerciseOptions(),
                                  direction: PopoverDirection.left,
                                  height: 175,
                                  width: 200,
                                  arrowDxOffset: 15,
                                  arrowHeight: 15,
                                  arrowWidth: 30,
                                ),
                                icon: const Icon(Icons.more_vert_rounded, color: Colors.black38, size: 25),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 5),
                        _getTextfields(),
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

  Widget _getTextfields() {
    if (widget.exercise.type == ExerciseType.setRep) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: smallGrey,
                controller: firstController,
                decoration: InputDecoration(
                  labelText: 'Set',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  labelStyle: smallGrey,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (changedValue) {
                  int firstValue = changedValue.isEmpty ? 0 : int.parse(changedValue);
                  int secondValue = int.tryParse(secondController.text) ?? 0;

                  widget.onTextfieldChange(firstValue, secondValue);
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: smallGrey,
                controller: secondController,
                decoration: InputDecoration(
                  labelText: 'Rep',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  labelStyle: smallGrey,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (changedValue) {
                  int firstValue = int.tryParse(firstController.text) ?? 0;
                  int secondValue = changedValue.isEmpty ? 0 : int.parse(changedValue);

                  widget.onTextfieldChange(firstValue, secondValue);

                  if (widget.exercise.type == ExerciseType.setRep && changedValue.isNotEmpty && firstValue == 0) {
                    firstController.text = '1';
                    widget.onTextfieldChange(1, secondValue);
                  }
                },
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: smallGrey,
                    controller: firstController,
                    decoration: InputDecoration(
                      labelText: 'Distance (optional)',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: smallGrey,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (changedValue) {
                      int firstValue = changedValue.isEmpty ? 0 : int.parse(changedValue);
                      int secondValue = int.tryParse(secondController.text) ?? 0;

                      widget.onTextfieldChange(firstValue, secondValue);
                    },
                  ),
                ),
                const SizedBox(width: 18),
                const Text('m', style: smallGrey),
                const SizedBox(width: 6),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    style: smallGrey,
                    controller: secondController,
                    decoration: InputDecoration(
                      labelText: 'Duration (optional)',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      labelStyle: smallGrey,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (changedValue) {
                      int firstValue = int.tryParse(firstController.text) ?? 0;
                      int secondValue = changedValue.isEmpty ? 0 : int.parse(changedValue);

                      widget.onTextfieldChange(firstValue, secondValue);

                      if (widget.exercise.type == ExerciseType.setRep && changedValue.isNotEmpty && firstValue == 0) {
                        firstController.text = '1';
                        widget.onTextfieldChange(1, secondValue);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                const Text('min', style: smallGrey),
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget _getExerciseOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              widget.onChangeType();
            },
            child: const SizedBox(
              height: 50,
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.black38),
                  SizedBox(width: 10),
                  Text('Change type', style: normalBlack),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const CustomDivider(),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              widget.onRemoveExercise();
              setState(() {});
            },
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red.shade300),
                  const SizedBox(width: 10),
                  const Text('Remove exercise', style: normalBlack),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const CustomDivider(),
          const SizedBox(height: 5),
          GestureDetector(
            // todo finish after detailed exercise page is done
            onTap: () {},
            child: const SizedBox(
              height: 50,
              child: Row(
                children: [
                  Icon(Icons.help_center_rounded, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text('About exercise', style: normalBlack),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
