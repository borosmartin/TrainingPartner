import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/text_util.dart';

class BodyPartPieChart extends StatelessWidget {
  final Map<String, int> bodyPartMap;

  const BodyPartPieChart({super.key, required this.bodyPartMap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 5),
              child: Icon(FontAwesomeIcons.dumbbell, size: 17),
            ),
            Text('${_getTotalSetNum()} sets', style: CustomTextStyle.bodySmallPrimary(context)),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: PieChart(
            PieChartData(
              sectionsSpace: 5,
              sections: showingSections(context),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(BuildContext context) {
    List<PieChartSectionData> sections = [];

    for (var bodyPart in bodyPartMap.entries) {
      sections.add(
        PieChartSectionData(
          color: _getChartColor(bodyPart.key),
          value: bodyPart.value.toDouble(),
          title: '${TextUtil.firstLetterToUpperCase(bodyPart.key)}\n${bodyPart.value} sets',
          titleStyle: CustomTextStyle.bodySmallTetriary(context),
          showTitle: true,
          radius: 100,
        ),
      );
    }

    return sections;
  }

  String _getTotalSetNum() {
    int totalSetNum = 0;

    for (var bodyPart in bodyPartMap.entries) {
      totalSetNum += bodyPart.value;
    }

    return totalSetNum.toString();
  }

  Color _getChartColor(String key) {
    var index = 0;

    for (var bodyPart in bodyPartMap.entries) {
      index++;
      if (bodyPart.key == key) {
        break;
      }
    }

    return chartColors[index];
  }
}
