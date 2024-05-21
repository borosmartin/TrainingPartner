import 'package:timezone/timezone.dart' as timezone;
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
        // API GIF url refresh time: 12:00pm US Central Time
        DateTime centralTimezoneRefreshTime = timezone.TZDateTime.from(
          DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0),
          timezone.getLocation('America/Chicago'),
        );

        DateTime now = DateTime.now();
        var difference = now.difference(hiveData.lastUpdated).inHours;
        if (now.isBefore(centralTimezoneRefreshTime.toLocal()) && difference < 12) {
          return hiveData;
        }
      }

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
