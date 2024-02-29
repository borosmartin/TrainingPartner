import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _getHeader(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _getHeader() {
    return const Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.chart_15),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Statistics', style: boldLargeBlack),
          ),
        ],
      ),
    );
  }
}
