import 'package:equatable/equatable.dart';

class ChartBuilderState extends Equatable {
  const ChartBuilderState();

  @override
  List<Object?> get props => [];
}

class ChartBuilderUninitialized extends ChartBuilderState {}

class ChartBuilderTypeSelected extends ChartBuilderState {}

class ChartBuilderValueSelected extends ChartBuilderState {}
