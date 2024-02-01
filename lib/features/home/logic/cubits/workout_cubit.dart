import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/features/home/data/repository/workout_repository.dart';
import 'package:training_partner/features/home/logic/states/workout_states.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _workoutRepository;

  WorkoutCubit(this._workoutRepository) : super(WorkoutsUninitialized());

  Future<void> saveWorkoutSession(String email, WorkoutSession session) async {
    try {
      await _workoutRepository.saveWorkoutSession(email, session);
    } catch (e) {
      emit(WorkoutSessionsError(message: e.toString()));
    }
  }

  Future<void> getWorkoutSessions() async {
    try {
      emit(WorkoutSessionsLoading());

      final sessions = await _workoutRepository.getAllSessionsFromHive();

      emit(WorkoutSessionsLoaded(workoutSessions: sessions));
    } catch (e) {
      emit(WorkoutSessionsError(message: e.toString()));
    }
  }

  // todo emailes delete?
  Future<void> deleteAllWorkoutSession() async {
    await _workoutRepository.deleteAllSessions();
  }
}
