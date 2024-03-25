import 'package:equatable/equatable.dart';

class ChartMinMaxValues extends Equatable {
  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  const ChartMinMaxValues({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  @override
  List<Object?> get props => [minX, maxX, minY, maxY];
}
