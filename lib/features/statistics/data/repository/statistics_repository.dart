import 'package:training_partner/features/statistics/data/service/statistics_local_service.dart';
import 'package:training_partner/features/statistics/models/chart.dart';

class StatisticsRepository {
  final StatisticsLocalService _statisticsLocalService;

  StatisticsRepository(this._statisticsLocalService);

  Future<void> saveChart(String email, Chart chart) async {
    await _statisticsLocalService.saveChart(email, chart);
  }

  Future<List<Chart>> getAllCharts(String email) async {
    return await _statisticsLocalService.getAllCharts(email);
  }

  Future<void> deleteChart(String email, Chart chart) async {
    await _statisticsLocalService.deleteChart(email, chart);
  }
}
