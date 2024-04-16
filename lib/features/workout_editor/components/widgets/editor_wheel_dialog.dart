import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';

class EditorWheelDialog extends StatefulWidget {
  final num? firstWheelValue;
  final num? secondWheelValue;
  final ExerciseType exerciseType;
  final Function(num, num) onValuesChange;
  final AppSettings settings;

  const EditorWheelDialog({
    super.key,
    this.firstWheelValue,
    this.secondWheelValue,
    required this.onValuesChange,
    required this.exerciseType,
    required this.settings,
  });

  @override
  State<EditorWheelDialog> createState() => _EditorWheelDialogState();
}

class _EditorWheelDialogState extends State<EditorWheelDialog> {
  ExerciseType get exerciseType => widget.exerciseType;

  late FixedExtentScrollController firstWheelScrollController;
  late FixedExtentScrollController secondWheelScrollController;

  num firstWheelValue = 0;
  num secondWheelValue = 0;

  @override
  void initState() {
    super.initState();

    firstWheelValue = widget.firstWheelValue ?? 0;
    secondWheelValue = widget.secondWheelValue ?? 0;

    firstWheelScrollController = FixedExtentScrollController(
      initialItem: exerciseType == ExerciseType.distance ? (firstWheelValue * 2).toInt() : firstWheelValue.toInt(),
    );
    secondWheelScrollController = FixedExtentScrollController(initialItem: secondWheelValue.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _getMiddleSelectedContainer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getHeader(),
                    _getWheels(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTitleButton(
              label: 'Set',
              onTap: () {
                widget.onValuesChange(
                  exerciseType == ExerciseType.distance ? (firstWheelValue / 2) : firstWheelValue,
                  secondWheelValue,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getHeader() {
    switch (exerciseType) {
      case ExerciseType.repetitions:
        return Column(children: [
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Padding(padding: const EdgeInsets.only(right: 15), child: Text('Sets', style: CustomTextStyle.titleSecondary(context))),
            Padding(padding: const EdgeInsets.only(left: 15), child: Text('Reps', style: CustomTextStyle.titleSecondary(context))),
          ]),
          const CustomDivider(thickness: 2.5, padding: EdgeInsets.symmetric(vertical: 15)),
        ]);

      case ExerciseType.distance:
        return Column(
          children: [
            const SizedBox(height: 15),
            Text('Distance', style: CustomTextStyle.titleSecondary(context)),
            const CustomDivider(thickness: 2.5, padding: EdgeInsets.symmetric(vertical: 15)),
          ],
        );

      case ExerciseType.duration:
        return Column(
          children: [
            const SizedBox(height: 15),
            Text('Duration', style: CustomTextStyle.titleSecondary(context)),
            const CustomDivider(thickness: 2.5, padding: EdgeInsets.symmetric(vertical: 15)),
          ],
        );
    }
  }

  Widget _getWheels() {
    if (exerciseType == ExerciseType.repetitions) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_getWheel(true), _getWheel(false)],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_getWheel(true)],
      );
    }
  }

  Widget _getWheel(bool isFirstWheel) {
    return SizedBox(
      height: 300,
      width: 100,
      child: ListWheelScrollView.useDelegate(
        controller: isFirstWheel ? firstWheelScrollController : secondWheelScrollController,
        itemExtent: 50,
        perspective: 0.009,
        diameterRatio: 4,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          if (isFirstWheel) {
            firstWheelValue = index;
          } else {
            secondWheelValue = index;
          }
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: 101,
          builder: (context, index) {
            return _getWheelItem(index, isFirstWheel);
          },
        ),
      ),
    );
  }

  Widget _getWheelItem(int num, bool isFirstWheel) {
    String numText = '';

    if (exerciseType == ExerciseType.distance) {
      numText = (num * 0.5).toString();
    } else {
      numText = num.toString();
    }

    return GestureDetector(
      onTap: () {
        if (isFirstWheel) {
          firstWheelScrollController.animateToItem(
            num,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } else {
          secondWheelScrollController.animateToItem(
            num,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
      },
      child: SizedBox(
        width: 70,
        child: Center(
          child: Text(numText, style: CustomTextStyle.titlePrimary(context)),
        ),
      ),
    );
  }

  Widget _getMiddleSelectedContainer() {
    List<Widget> children = [];

    switch (exerciseType) {
      case ExerciseType.repetitions:
        children = [
          Padding(padding: const EdgeInsets.only(left: 60), child: Text('#', style: CustomTextStyle.bodySmallSecondary(context))),
          Padding(padding: const EdgeInsets.only(left: 35), child: Text('#', style: CustomTextStyle.bodySmallSecondary(context))),
        ];
        break;

      case ExerciseType.distance:
        children = [
          Padding(
            padding: const EdgeInsets.only(left: 100),
            child: Text(widget.settings.distanceUnit == DistanceUnit.km ? 'km' : 'miles', style: CustomTextStyle.bodySmallSecondary(context)),
          )
        ];
        break;

      case ExerciseType.duration:
        children = [Padding(padding: const EdgeInsets.only(left: 80), child: Text('min', style: CustomTextStyle.bodySmallSecondary(context)))];
        break;
    }

    return Positioned(
      bottom: 125,
      child: Container(
        width: 290,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: defaultBorderRadius,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: children,
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstWheelScrollController.dispose();
    secondWheelScrollController.dispose();

    super.dispose();
  }
}
