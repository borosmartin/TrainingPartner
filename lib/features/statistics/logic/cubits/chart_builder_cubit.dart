import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/features/statistics/logic/states/chart_builder_state.dart';

class ChartBuilderCubit extends Cubit<ChartBuilderState> {
  ChartBuilderCubit() : super(ChartBuilderUninitialized());

  void toFirstStage() {
    emit(ChartBuilderUninitialized());
  }

  void toSecondStage() {
    emit(ChartBuilderTypeSelected());
  }

  void toThirdStage() {
    emit(ChartBuilderValueSelected());
  }
}
