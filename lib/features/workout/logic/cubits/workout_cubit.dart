import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/features/workout/data/repository/workout_repository.dart';
import 'package:training_partner/features/workout/logic/states/workout_state.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutCubit extends Cubit<WorkoutState> {
  final WorkoutRepository _workoutRepository;

  WorkoutCubit(this._workoutRepository) : super(WorkoutUninitialized());

  Future<void> saveWorkoutSession(WorkoutSession workoutSession) async {
    try {
      emit(WorkoutLoading());

      await _workoutRepository.saveWorkoutSession(currentUser.email!, workoutSession);

      emit(WorkoutSaved(session: workoutSession));
    } catch (error, stackTrace) {
      emit(WorkoutError(message: 'Error: $error, stackTrace: $stackTrace'));
    }
  }

  Future<void> getAllWorkoutSession() async {
    try {
      emit(WorkoutLoading());

      List<WorkoutSession> workoutSessions = await _workoutRepository.getAllWorkoutSession(currentUser.email!);

      emit(WorkoutSessionsLoaded(sessions: workoutSessions));
    } catch (error, stackTrace) {
      emit(WorkoutError(message: 'Error: $error, stackTrace: $stackTrace'));
    }
  }
}
