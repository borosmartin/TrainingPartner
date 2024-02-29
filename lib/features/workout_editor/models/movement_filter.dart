import 'package:equatable/equatable.dart';

class MovementFilter extends Equatable {
  final String? searchQuery;
  final List<String>? targets;
  final List<String>? bodyParts;
  final String? equipment;

  const MovementFilter({
    this.searchQuery,
    this.targets,
    this.bodyParts,
    this.equipment,
  });

  MovementFilter copyWith({
    String? searchQuery,
    List<String>? targets,
    List<String>? bodyParts,
    String? equipment,
  }) {
    return MovementFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      targets: targets ?? this.targets,
      bodyParts: bodyParts ?? this.bodyParts,
      equipment: equipment ?? this.equipment,
    );
  }

  @override
  List<Object?> get props => [searchQuery, targets, bodyParts, equipment];
}
