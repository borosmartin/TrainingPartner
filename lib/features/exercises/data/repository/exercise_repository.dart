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
        // todo emulátron 1 órával folyton visszább áll
        DateTime now = DateTime.now();
        DateTime todayRefreshTime = DateTime(now.year, now.month, now.day, 19, 0);

        var difference = now.difference(hiveData.lastUpdated).inHours;
        if (now.isBefore(todayRefreshTime) && difference < 22) {
          return hiveData;
        }
      }

      // todo törölni a cachelt képeket, kell e egyáltalán?
      // CachedNetworkImage.evictFromCache();
      MovementData apiData = await _exerciseService.fetchMovementList();
      _exerciseServiceLocal.saveMovementData(apiData);
      return apiData;
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
