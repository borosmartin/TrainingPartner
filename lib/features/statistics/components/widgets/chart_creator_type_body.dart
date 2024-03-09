import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/statistics/logic/states/chart_builder_state.dart';

class ChartCreatorTypeBody extends StatefulWidget {
  final Function(ChartBuilderChartType? type) onChartTypeSelected;

  const ChartCreatorTypeBody({Key? key, required this.onChartTypeSelected}) : super(key: key);

  @override
  State<ChartCreatorTypeBody> createState() => _ChartCreatorTypeBodyState();
}

class _ChartCreatorTypeBodyState extends State<ChartCreatorTypeBody> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _getItem(
          index: 0,
          name: 'Workout',
          type: ChartBuilderChartType.workout,
          iconData: Iconsax.note_215,
        ),
        const SizedBox(width: 10),
        _getItem(
          index: 1,
          name: 'Exercise',
          type: ChartBuilderChartType.exercise,
          iconData: FontAwesomeIcons.personRunning,
        ),
        const SizedBox(width: 10),
        _getItem(
          index: 2,
          name: 'Muscle',
          type: ChartBuilderChartType.muscle,
          iconData: Iconsax.weight_15,
        ),
      ],
    );
  }

  Widget _getItem({required int index, required String name, required ChartBuilderChartType type, required IconData iconData}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (selectedIndex == index) {
              selectedIndex = null;
            } else {
              selectedIndex = index;
            }

            widget.onChartTypeSelected(selectedIndex != null ? type : null);
          });
        },
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: defaultBorderRadius,
            side: BorderSide(color: selectedIndex == index ? Theme.of(context).colorScheme.tertiary : Colors.transparent, width: 2.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Icon(iconData, size: 30, color: selectedIndex == index ? Theme.of(context).colorScheme.tertiary : Colors.black),
                const SizedBox(height: 10),
                Text(name, style: selectedIndex == index ? boldNormalAccent : boldNormalGrey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
