import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class WorkoutWheelDialog extends StatefulWidget {
  final num? firstValue;
  final num? secondValue;
  final ExerciseType exerciseType;
  final Function(num, num) onSetValuesChange;

  const WorkoutWheelDialog({
    super.key,
    required this.firstValue,
    required this.secondValue,
    required this.onSetValuesChange,
    required this.exerciseType,
  });

  @override
  State<WorkoutWheelDialog> createState() => _EditorWheelDialogState();
}

class _EditorWheelDialogState extends State<WorkoutWheelDialog> {
  late FixedExtentScrollController firstScrollController;
  late FixedExtentScrollController secondScrollController;

  late num firstValue;
  late num secondValue;

  late bool isSetRep;

  @override
  void initState() {
    super.initState();

    firstValue = widget.firstValue ?? 0;
    secondValue = widget.secondValue ?? 0;

    isSetRep = widget.exerciseType == ExerciseType.setRep;

    firstScrollController = FixedExtentScrollController(initialItem: firstValue.toInt());
    secondScrollController = FixedExtentScrollController(initialItem: secondValue.toInt());
  }

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
                widget.onSetValuesChange(firstValue, secondValue);
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
      return const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text('Rep', style: boldLargeGrey),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text('Weight', style: boldLargeGrey),
              ),
            ],
          ),
          CustomDivider(thickness: 2.5, padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(firstValue != 0 ? 'Distance' : 'Duration', style: boldLargeGrey),
          ),
          const CustomDivider(thickness: 2.5, padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      );
    }
  }

  Widget _getWheels() {
    if (isSetRep) {
      return Row(
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
              onSelectedItemChanged: (index) => firstValue = index,
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
              onSelectedItemChanged: (index) => secondValue = index,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: (100),
                builder: (context, index) {
                  // todo weight increments
                  return _getListWheelItem(index, false);
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
              onSelectedItemChanged: (index) => firstValue = index,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 100,
                builder: (context, index) {
                  return _getListWheelItem(index, firstValue != 0);
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  // todo első 4 item valamiért más
  Widget _getListWheelItem(num num, bool isFirst) {
    return GestureDetector(
      onTap: () {
        if (isFirst) {
          firstScrollController.animateToItem(
            num.toInt(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } else {
          secondScrollController.animateToItem(
            num.toInt(),
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
    List<Widget> children = [];

    if (isSetRep) {
      children.addAll([
        Padding(
          padding: EdgeInsets.only(left: isSetRep ? 60 : 85),
          child: Text(!isSetRep ? 'm' : '#', style: smallGrey),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35),
          child: Text(!isSetRep ? 'min' : 'kg', style: smallGrey),
        ),
      ]);
    } else {
      if (firstValue == 0) {
        children.add(const Padding(
          padding: EdgeInsets.only(left: 70),
          child: Text('min', style: smallGrey),
        ));
      } else {
        children.add(const Padding(
          padding: EdgeInsets.only(left: 60),
          child: Text('km', style: smallGrey),
        ));
      }
    }

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
          children: children,
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
