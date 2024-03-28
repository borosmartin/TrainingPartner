import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/statistics/data/service/statistics_local_service.dart';
import 'package:training_partner/features/statistics/models/chart.dart';

class StatisticsRepository {
  final StatisticsLocalService _statisticsLocalService;

  StatisticsRepository(this._statisticsLocalService);

  Future<void> createChart(String email, Chart chart) async {
    try {
      await fireStore.collection('statistics').doc('$email - ${chart.id}').set(chart.toJson());

      await _statisticsLocalService.saveChart(email, chart);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Chart>> getAllChart(String email) async {
    try {
      List<Chart> charts = [];

      await fireStore.collection('statistics').get().then((snapShot) {
        for (var chart in snapShot.docs) {
          if (chart.id.contains(email)) {
            charts.add(Chart.fromJson(chart.data()));
          }
        }
      });

      return charts;
    } catch (e) {
      try {
        return await _statisticsLocalService.getAllCharts(email);
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<void> deleteChart(String email, Chart chart) async {
    try {
      await fireStore.collection('statistics').doc('$email - ${chart.id}').delete();

      await _statisticsLocalService.deleteChart(email, chart);
    } catch (e) {
      rethrow;
    }
  }
}
