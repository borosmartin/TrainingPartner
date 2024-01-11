import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final String gifUrl;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  const Exercise({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.gifUrl,
    required this.secondaryMuscles,
    required this.instructions,
  });

  factory Exercise.fromCSV(Map<String, dynamic> csv) {
    return Exercise(
      id: csv['id'],
      name: csv['name'],
      bodyPart: csv['body_part'],
      equipment: csv['equipment'],
      target: csv['target'],
      gifUrl: csv['gif_url'],
      secondaryMuscles: List<String>.from(csv['secondary_muscles']),
      instructions: List<String>.from(csv['instructions']),
    );
  }

  @override
  List<Object?> get props => [id, name, bodyPart, equipment, target, gifUrl, secondaryMuscles, instructions];
}
