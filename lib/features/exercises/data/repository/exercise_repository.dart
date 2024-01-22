import 'package:training_partner/features/exercises/data/service/exercise_local_service.dart';
import 'package:training_partner/features/exercises/data/service/exercise_service.dart';
import 'package:training_partner/features/exercises/models/movement.dart';

class ExerciseRepository {
  final ExerciseService _exerciseService;
  final ExerciseServiceLocal _exerciseServiceLocal;

  ExerciseRepository(this._exerciseService, this._exerciseServiceLocal);

  Future<MovementData> fetchMovementList() async {
    try {
      MovementData? hiveData = await _exerciseServiceLocal.getMovementDataFromHive();

      if (hiveData != null) {
        DateTime lastUpdated = hiveData.lastUpdated;
        DateTime now = DateTime.now();

        // The movements gif urls reset everyday at 19:00
        DateTime dailyRefreshTime = DateTime(
          now.year,
          now.month,
          now.day,
          19,
          0,
        );

        if (now.isAfter(dailyRefreshTime) && lastUpdated.isBefore(dailyRefreshTime)) {
          MovementData apiData = await _exerciseService.fetchMovementList();
          await _exerciseServiceLocal.saveMovementData(apiData);
          return apiData;
        } else {
          return hiveData;
        }
      } else {
        MovementData apiData = await _exerciseService.fetchMovementList();
        await _exerciseServiceLocal.saveMovementData(apiData);
        return apiData;
      }
    } catch (error) {
      try {
        MovementData? hiveData = await _exerciseServiceLocal.getMovementDataFromHive();
        if (hiveData != null) {
          return hiveData;
        } else {
          rethrow;
        }
      } catch (error) {
        rethrow;
      }
    }
  }
}
