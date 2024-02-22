import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class EditorWheelDialog extends StatefulWidget {
  final int firstValue;
  final int secondValue;
  final ExerciseType exerciseType;
  final Function(int, int) onSetValuesChange;

  const EditorWheelDialog({
    super.key,
    required this.firstValue,
    required this.secondValue,
    required this.onSetValuesChange,
    required this.exerciseType,
  });

  @override
  State<EditorWheelDialog> createState() => _EditorWheelDialogState();
}

class _EditorWheelDialogState extends State<EditorWheelDialog> {
  late FixedExtentScrollController firstScrollController;
  late FixedExtentScrollController secondScrollController;

  int setDistance = 0;
  int repDuration = 0;

  bool isHelpVisible = false;
  late bool isSetRep;

  @override
  void initState() {
    super.initState();

    setDistance = widget.firstValue;
    repDuration = widget.secondValue;

    isSetRep = widget.exerciseType == ExerciseType.setRep;

    firstScrollController = FixedExtentScrollController(initialItem: !isSetRep ? (setDistance / 100).round() : setDistance);
    secondScrollController = FixedExtentScrollController(initialItem: repDuration);
  }

  // todo csak distance vagy duration lehet, nem mindkettő!
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: defaultCornerShape,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.flag_rounded),
                const SizedBox(width: 10),
                const Text('Set your goals', style: boldNormalBlack),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => isHelpVisible = !isHelpVisible),
                  child: const Icon(Icons.help_outline_rounded, color: Colors.black38, size: 28),
                ),
              ],
            ),
            SizedBox(height: isHelpVisible ? 0 : 10),
            Stack(
              alignment: Alignment.center,
              children: [
                _getMiddleSelectedContainer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getHeader(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 300,
                          width: 100,
                          child: ListWheelScrollView.useDelegate(
                            controller: firstScrollController,
                            itemExtent: 50,
                            perspective: 0.009,
                            diameterRatio: 4,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) => setDistance = index,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 100,
                              builder: (context, index) {
                                return _getListWheelItem(index, true);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          width: 100,
                          child: ListWheelScrollView.useDelegate(
                            controller: secondScrollController,
                            itemExtent: 50,
                            perspective: 0.009,
                            diameterRatio: 4,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) => repDuration = index,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: 100,
                              builder: (context, index) {
                                return _getListWheelItem(index, false);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomTitleButton(
              label: 'Set',
              onTap: () {
                int modifiedSetDistance = !isSetRep && 100 > setDistance ? (setDistance * 100) : setDistance;
                widget.onSetValuesChange(modifiedSetDistance, repDuration);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getHeader() {
    if (isSetRep) {
      return Column(
        children: [
          Visibility(
            visible: isHelpVisible,
            child: const Text(
              '- Here you can set the number of sets and repetitions for the chosen exercise.\n- Both of them are mandatory.',
              style: smallGrey,
            ),
          ),
          const CustomDivider(
            thickness: 2.5,
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text('Set', style: boldLargeGrey),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text('Rep', style: boldLargeGrey),
              ),
            ],
          ),
          const CustomDivider(thickness: 2.5, padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      );
    } else {
      return Column(
        children: [
          Visibility(
            visible: isHelpVisible,
            child: const Text(
              '- Here you can set the distance or the duration for the chosen exercise.\n- Distance is in meters, duration is in minutes.\n- Both of them are optional.',
              style: smallGrey,
            ),
          ),
          const CustomDivider(
            thickness: 2.5,
            padding: EdgeInsets.symmetric(vertical: 10),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text('Distance', style: boldLargeGrey),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text('Duration', style: boldLargeGrey),
              ),
            ],
          ),
          const CustomDivider(thickness: 2.5, padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      );
    }
  }

  Widget _getListWheelItem(int num, bool isFirst) {
    return GestureDetector(
      onTap: () {
        if (isFirst) {
          firstScrollController.animateToItem(
            num,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } else {
          secondScrollController.animateToItem(
            num,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
      },
      child: SizedBox(
        width: 70,
        child: Center(
          child: Text(
            isFirst && !isSetRep ? (num * 100).toString() : num.toString(),
            style: boldLargeBlack,
          ),
        ),
      ),
    );
  }

  Widget _getMiddleSelectedContainer() {
    return Positioned(
      bottom: 125,
      child: Container(
        width: 290,
        height: 50,
        decoration: const BoxDecoration(
          borderRadius: defaultBorderRadius,
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.only(left: isSetRep ? 60 : 85),
              child: Text(!isSetRep ? 'm' : '#', style: smallGrey),
            ),
            Padding(
              padding: EdgeInsets.only(left: isSetRep ? 35 : 35),
              child: Text(!isSetRep ? 'min' : '#', style: smallGrey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    firstScrollController.dispose();
    secondScrollController.dispose();

    super.dispose();
  }
}
