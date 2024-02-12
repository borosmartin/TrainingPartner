import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/features/exercises/data/repository/exercise_repository.dart';
import 'package:training_partner/features/exercises/logic/states/exercise_state.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/home/models/movement_filter.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  final ExerciseRepository _exerciseRepository;

  ExerciseCubit(this._exerciseRepository) : super(ExercisesUninitialized());

  Future<void> loadMovements() async {
    try {
      emit(MovementsLoading());

      var movementData = await _exerciseRepository.fetchMovementList();

      emit(MovementsLoaded(movements: movementData.movements));
    } catch (error, stackTrace) {
      emit(MovementsError('Error: $error\nStacktrace: $stackTrace'));
    }
  }

  Future<void> filterMovements(List<Movement> allMovements, MovementFilter filter) async {
    try {
      emit(MovementsLoading());

      final filteredMovements = allMovements.where((movement) {
        final containsSearchQuery = filter.searchQuery == null || movement.name.toLowerCase().contains(filter.searchQuery!.toLowerCase());

        final matchesEquipment = filter.equipment == null || filter.equipment == 'all' || movement.equipment == filter.equipment;

        final matchesTargets = filter.targets == null || filter.targets!.isEmpty || filter.targets!.contains(movement.target);

        final matchesBodyParts =
            filter.bodyParts == null || filter.bodyParts!.isEmpty || filter.bodyParts!.any((bodyPart) => movement.bodyPart.contains(bodyPart));

        return containsSearchQuery && matchesEquipment && matchesTargets && matchesBodyParts;
      }).toList();

      emit(MovementsLoaded(movements: allMovements, filteredMovements: filteredMovements, previousFilter: filter));
    } catch (error, stackTrace) {
      emit(MovementsError('Error: $error\nStacktrace: $stackTrace'));
    }
  }

// TODO remove later if not needed
  // Future<void> loadExercisesFromCsv() async {
  //   try {
  //     emit(ExercisesLoading());
  //
  //     String csvString = await rootBundle.loadString('assets/csv/movements.csv');
  //     List<String> lines = csvString.split('\n');
  //     List<String> headers = lines[0].split(';');
  //     final List<Movement> exercises = [];
  //
  //     lines.removeWhere((value) => value.isEmpty);
  //     headers = headers.map((value) => value.contains('\r') ? value.replaceAll('\r', '').trim() : value).toList();
  //
  //     for (int i = 1; i < lines.length; i++) {
  //       var lineValues = lines[i].split(';');
  //
  //       final Map<String, dynamic> exercise = {};
  //       for (int j = 0; j < headers.length; j++) {
  //         exercise[headers[j]] = lineValues[j];
  //       }
  //
  //       exercise.removeWhere((key, value) => value == null || value == "null");
  //
  //       if (exercise['name'] is String && exercise['name'].isNotEmpty && exercise['name'][0] == exercise['name'][0].toLowerCase()) {
  //         exercise['name'] = exercise['name'].replaceFirst(exercise['name'][0], exercise['name'][0].toUpperCase());
  //       }
  //
  //       exercises.add(Movement.fromCSV(exercise));
  //     }
  //
  //     emit(ExercisesLoaded(exercises));
  //   } catch (error, stackTrace) {
  //     emit(ExercisesError('Error: $error\nStackTrace: $stackTrace'));
  //   }
  // }
}
