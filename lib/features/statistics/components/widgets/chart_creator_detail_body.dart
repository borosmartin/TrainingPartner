import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/statistics/logic/states/chart_builder_state.dart';

class ChartCreatorDetailBody extends StatefulWidget {
  final ChartBuilderChartType type;

  const ChartCreatorDetailBody({Key? key, required this.type}) : super(key: key);

  @override
  State<ChartCreatorDetailBody> createState() => _ChartCreatorDetailBodyState();
}

class _ChartCreatorDetailBodyState extends State<ChartCreatorDetailBody> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(children: []);
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
