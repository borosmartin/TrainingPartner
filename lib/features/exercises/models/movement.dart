import 'package:equatable/equatable.dart';
import 'package:training_partner/core/utils/text_util.dart';

class MovementData extends Equatable {
  final List<Movement> movements;
  final DateTime lastUpdated;

  const MovementData(this.movements, this.lastUpdated);

  factory MovementData.fromService(List<dynamic> jsonDataList) {
    final List<Movement> movements = [];

    for (var movement in jsonDataList) {
      movements.add(Movement.fromJson(movement));
    }

    return MovementData(
      movements,
      DateTime.now(),
    );
  }

  factory MovementData.fromJson(Map<String, dynamic> json) {
    final List<Movement> movements = [];

    if (json['movements'] is List) {
      for (var movement in json['movements'] as List) {
        Map<String, dynamic> typedMovement = {};
        movement.forEach((key, value) {
          typedMovement[key.toString()] = value;
        });

        movements.add(Movement.fromJson(typedMovement));
      }
    }

    return MovementData(
      movements,
      json['lastUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movements': movements.map((movement) => movement.toJson()).toList(),
      'lastUpdated': lastUpdated,
    };
  }

  @override
  List<Object> get props => [movements, lastUpdated];
}

class Movement extends Equatable {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final String gifUrl;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  const Movement({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.gifUrl,
    required this.secondaryMuscles,
    required this.instructions,
  });

  factory Movement.fromJson(Map json) {
    String name = json['name'] ?? '';
    if (name.isNotEmpty) {
      name = TextUtil.firstLetterToUpperCase(name);
    }

    return Movement(
      id: json['id'] ?? '',
      name: name,
      bodyPart: json['bodyPart'] ?? '',
      equipment: json['equipment'] ?? '',
      target: json['target'] ?? '',
      gifUrl: json['gifUrl'] ?? '',
      secondaryMuscles: json['secondaryMuscles']?.cast<String>() ?? [],
      instructions: json['instructions']?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'equipment': equipment,
      'target': target,
      'gifUrl': gifUrl,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
    };

    return json;
  }

  // todo remove if not needed
  factory Movement.fromCSV(Map<String, dynamic> csv) {
    final List<String> secondaryMusclesList = [];
    final List<String> instructionsList = [];

    csv.forEach((key, value) {
      if (key.contains('secondaryMuscles')) {
        secondaryMusclesList.add(value);
      }
      if (key.contains('instructions')) {
        instructionsList.add(value);
      }
    });

    return Movement(
      id: csv['id'] ?? '',
      name: csv['name'] ?? '',
      bodyPart: csv['bodyPart'] ?? '',
      equipment: csv['equipment'] ?? '',
      target: csv['target'] ?? '',
      gifUrl: csv['gifUrl'] ?? '',
      secondaryMuscles: secondaryMusclesList,
      instructions: instructionsList,
    );
  }

  @override
  List<Object?> get props => [id, name, bodyPart, equipment, target, gifUrl, secondaryMuscles, instructions];
}
