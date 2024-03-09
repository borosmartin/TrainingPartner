import 'package:equatable/equatable.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

enum ChartBuilderChartType { workout, exercise, muscle }

class ChartBuilderState extends Equatable {
  const ChartBuilderState();

  @override
  List<Object?> get props => [];
}

class ChartBuilderUninitialized extends ChartBuilderState {}

class ChartBuilderTypeSelected extends ChartBuilderState {
  final ChartBuilderChartType chartType;

  const ChartBuilderTypeSelected({required this.chartType});

  @override
  List<Object?> get props => [chartType];
}

class ChartBuilderValueSelected extends ChartBuilderState {
  final String? muscle;
  final Exercise? exercise;

  const ChartBuilderValueSelected({this.muscle, this.exercise});

  @override
  List<Object?> get props => [muscle, exercise];
}
