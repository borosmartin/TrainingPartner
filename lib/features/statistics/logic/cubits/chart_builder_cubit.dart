import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/statistics/logic/states/chart_builder_state.dart';

class ChartBuilderCubit extends Cubit<ChartBuilderState> {
  ChartBuilderCubit() : super(ChartBuilderUninitialized());

  void toFirstStage() {
    emit(ChartBuilderUninitialized());
  }

  void toSecondStage(ChartBuilderChartType chartType) {
    emit(ChartBuilderTypeSelected(chartType: chartType));
  }

  void toThirdStage({String? muscle, Exercise? exercise}) {
    emit(ChartBuilderValueSelected(muscle: muscle, exercise: exercise));
  }
}
