import 'package:training_partner/features/statistics/models/chart_options.dart';

enum ChartBuilderChartType { workout, exercise, muscle }

class Chart {
  String id;

  // stage 1
  ChartBuilderChartType? type;

  // stage 2
  String? muscleTarget;
  String? exerciseId;

  // stage 3
  ChartOptions chartOptions;

  Chart({
    required this.id,
    this.type,
    this.muscleTarget,
    this.exerciseId,
    this.chartOptions = const ChartOptions(),
  });

  factory Chart.fromJson(dynamic json) {
    return Chart(
      id: json['id'],
      type: ChartBuilderChartType.values.firstWhere((e) => e.toString() == json['type']),
      muscleTarget: json['muscle'],
      exerciseId: json['exerciseId'],
      chartOptions: ChartOptions.fromJson(json['chartOptions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'muscle': muscleTarget,
      'exerciseId': exerciseId,
      'chartOptions': chartOptions.toJson(),
    };
  }
}
