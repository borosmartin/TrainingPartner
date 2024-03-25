import 'package:equatable/equatable.dart';
import 'package:training_partner/features/statistics/models/chart.dart';

class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => [];
}

class StatisticsUninitialized extends StatisticsState {}

class ChartsLoading extends StatisticsState {}

class ChartsLoaded extends StatisticsState {
  final List<Chart> charts;

  const ChartsLoaded(this.charts);

  @override
  List<Object?> get props => [charts];
}

class ChartAddSuccess extends StatisticsState {}

class ChartDeleteSuccess extends StatisticsState {}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}
