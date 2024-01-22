import 'package:flutter/cupertino.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Statistics', style: boldNormalBlack),
      ],
    );
  }
}
