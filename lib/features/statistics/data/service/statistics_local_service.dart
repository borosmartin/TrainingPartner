import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/features/statistics/models/chart.dart';

class StatisticsLocalService {
  static const String statisticsBoxKey = 'statisticsBox';

  Future<void> saveChart(String email, Chart chart) async {
    final box = await Hive.openBox(statisticsBoxKey);

    final json = chart.toJson();
    final key = '$email - ${chart.id}';

    await box.put(key, json);
  }

  Future<List<Chart>> getAllCharts(String email) async {
    final box = await Hive.openBox(statisticsBoxKey);
    // box.clear();

    final jsonList = box.keys.where((key) => key.startsWith(email));
    final List<Chart> charts = [];

    for (var key in jsonList) {
      final jsonChart = await box.get(key);
      final Chart chart = Chart.fromJson(jsonChart);
      charts.add(chart);
    }

    return charts;
  }

  Future<void> deleteChart(String email, Chart chart) async {
    final box = await Hive.openBox(statisticsBoxKey);

    final key = '$email - ${chart.id}';
    await box.delete(key);
  }
}
