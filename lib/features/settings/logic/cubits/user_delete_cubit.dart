import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/open_ai/gpt_repository.dart';
import 'package:training_partner/features/settings/data/repository/settings_repository.dart';
import 'package:training_partner/features/settings/logic/cubits/user_delete_state.dart';
import 'package:training_partner/features/statistics/data/repository/statistics_repository.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
import 'package:training_partner/features/workout/data/repository/workout_repository.dart';
import 'package:training_partner/features/workout_editor/data/repository/workout_plan_repository.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class UserDeleteCubit extends Cubit<UserDeleteState> {
  final GptRepository _gptRepository;
  final SettingsRepository _settingsRepository;
  final WorkoutPlanRepository _workoutPlanRepository;
  final WorkoutRepository _workoutRepository;
  final StatisticsRepository _statisticsRepository;

  UserDeleteCubit(
    this._gptRepository,
    this._settingsRepository,
    this._workoutPlanRepository,
    this._workoutRepository,
    this._statisticsRepository,
  ) : super(UserDeleteUninitialized());

  Future<void> deleteUser() async {
    try {
      emit(UserDeleteLoading());

      await _gptRepository.deleteAllGptTipFromHive(currentUser.email!);

      await _settingsRepository.deleteSettings(currentUser.email!);

      final List<WorkoutPlan> workoutPlans = await _workoutPlanRepository.getAllWorkoutPlan(currentUser.email!);
      for (var plan in workoutPlans) {
        await _workoutPlanRepository.deleteWorkoutPlan(currentUser.email!, plan);
      }

      final List<WorkoutSession> sessions = await _workoutRepository.getAllPreviousWorkouts(currentUser.email!);
      for (var session in sessions) {
        await _workoutRepository.deleteWorkoutSession(currentUser.email!, session);
      }

      final List<Chart> charts = await _statisticsRepository.getAllChart(currentUser.email!);
      for (var chart in charts) {
        await _statisticsRepository.deleteChart(currentUser.email!, chart);
      }

      await AuthService().signOut();
      await AuthService().deleteAccount();
      emit(UserDeleteSuccess());
    } catch (error, stackTrace) {
      emit(UserDeleteError(message: 'Error: $error, stackTrace: $stackTrace'));
    }
  }
}
