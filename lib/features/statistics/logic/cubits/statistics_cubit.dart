import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/statistics/data/repository/statistics_repository.dart';
import 'package:training_partner/features/statistics/logic/states/statistics_state.dart';
import 'package:training_partner/features/statistics/models/chart.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _statisticsRepository;

  StatisticsCubit(this._statisticsRepository) : super(StatisticsUninitialized());

  Future<void> saveChart(Chart chart) async {
    try {
      _statisticsRepository.saveChart(currentUser.email!, chart);

      emit(ChartAddSuccess());
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

  Future<void> loadAllCharts() async {
    try {
      emit(ChartsLoading());

      final charts = await _statisticsRepository.getAllCharts(currentUser.email!);

      emit(ChartsLoaded(charts));
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

  Future<void> deleteChart(Chart chart) async {
    try {
      _statisticsRepository.deleteChart(currentUser.email!, chart);

      emit(ChartDeleteSuccess());
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }
}
