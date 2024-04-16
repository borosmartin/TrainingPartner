import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/workout/data/repository/workout_repository.dart';
import 'package:training_partner/features/workout/logic/states/workout_state.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _workoutRepository;

  WorkoutCubit(this._workoutRepository) : super(WorkoutUninitialized());

  Future<void> completeWorkoutSession(WorkoutSession workoutSession) async {
    try {
      emit(WorkoutLoading());

      await _workoutRepository.saveWorkoutSession(currentUser.email!, workoutSession);
      List<WorkoutSession> workoutSessions = await _workoutRepository.getAllPreviousWorkouts(currentUser.email!);

      emit(WorkoutSessionsLoaded(sessions: workoutSessions, isCompleted: true));
    } catch (error, stackTrace) {
      emit(WorkoutError(errorMessage: 'Error: $error, stackTrace: $stackTrace'));
    }
  }

  Future<void> deleteWorkoutSession(WorkoutSession workoutSession) async {
    try {
      emit(WorkoutLoading());

      await _workoutRepository.deleteWorkoutSession(currentUser.email!, workoutSession);
      List<WorkoutSession> workoutSessions = await _workoutRepository.getAllPreviousWorkouts(currentUser.email!);

      emit(WorkoutSessionsLoaded(sessions: workoutSessions, isDeleted: true));
    } catch (error, stackTrace) {
      emit(WorkoutError(errorMessage: 'Error: $error, stackTrace: $stackTrace'));
    }
  }

  Future<void> getAllPreviousWorkouts() async {
    try {
      emit(WorkoutLoading());

      List<WorkoutSession> workoutSessions = await _workoutRepository.getAllPreviousWorkouts(currentUser.email!);

      emit(WorkoutSessionsLoaded(sessions: workoutSessions));
    } catch (error, stackTrace) {
      emit(WorkoutError(errorMessage: 'Error: $error, stackTrace: $stackTrace'));
    }
  }
}
