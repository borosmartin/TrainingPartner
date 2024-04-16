import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/statistics/models/chart.dart';

import '../../../../config/theme/custom_text_theme.dart';

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
          iconData: PhosphorIconsBold.barbell,
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
          iconData: PhosphorIconsBold.target,
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
          color: selectedIndex == index ? accentColor : Theme.of(context).cardColor,
          shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Icon(iconData, size: 30, color: selectedIndex == index ? Colors.white : Theme.of(context).colorScheme.tertiary),
                const SizedBox(height: 10),
                Text(name, style: selectedIndex == index ? CustomTextStyle.bodyTetriary(context) : CustomTextStyle.bodyPrimary(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
