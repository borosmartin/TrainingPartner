import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/features/exercises/data/repository/exercise_repository.dart';
import 'package:training_partner/features/exercises/logic/states/movement_state.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout_editor/models/movement_filter.dart';

class MovementCubit extends Cubit<MovementState> {
  final ExerciseRepository _exerciseRepository;

  MovementCubit(this._exerciseRepository) : super(MovementsUninitialized());

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
}
