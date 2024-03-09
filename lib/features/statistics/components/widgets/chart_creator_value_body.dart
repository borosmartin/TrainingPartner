import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/statistics/logic/states/chart_builder_state.dart';

class ChartCreatorValueBody extends StatefulWidget {
  final ChartBuilderChartType type;
  final List<Movement> movements;
  final Function(String?) onMuscleSelected;

  const ChartCreatorValueBody({
    Key? key,
    required this.type,
    required this.movements,
    required this.onMuscleSelected,
  }) : super(key: key);

  @override
  State<ChartCreatorValueBody> createState() => _ChartCreatorValueBodyState();
}

class _ChartCreatorValueBodyState extends State<ChartCreatorValueBody> {
  List<Movement> get movements => widget.movements;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    Map<int, String> muscles = _getMuscles();

    List<Widget> muscleWidgets = [];
    for (var entry in muscles.entries) {
      muscleWidgets.add(_getMuscleCard(index: entry.key, name: entry.value));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: muscleWidgets.sublist(0, muscleWidgets.length ~/ 2),
        ),
        Column(
          children: muscleWidgets.sublist(muscleWidgets.length ~/ 2),
        ),
      ],
    );
  }

  Widget _getMuscleCard({required int index, required String name}) {
    double width = (MediaQuery.of(context).size.width - 70) / 2;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedIndex == index) {
            selectedIndex = null;
          } else {
            selectedIndex = index;
          }

          widget.onMuscleSelected(selectedIndex != null ? name : null);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: SizedBox(
          width: width,
          child: Card(
            elevation: 0,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: defaultBorderRadius,
              side: BorderSide(color: selectedIndex == index ? Theme.of(context).colorScheme.tertiary : Colors.transparent, width: 2.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Text(
                  name,
                  style: selectedIndex == index ? boldNormalAccent : boldNormalGrey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<int, String> _getMuscles() {
    Map<int, String> muscles = {};

    int index = 0;
    for (int i = 0; i < movements.length; i++) {
      if (movements[i].bodyPart != 'cardio') {
        if (!muscles.values.contains(movements[i].target)) {
          muscles[index] = movements[i].target;
          index++;
        }
      }
    }

    for (int i = 0; i < muscles.length; i++) {
      muscles[i] = TextUtil.firstLetterToUpperCase(muscles.values.elementAt(i));
    }

    muscles = Map.fromEntries(muscles.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));

    return muscles;
  }
}
