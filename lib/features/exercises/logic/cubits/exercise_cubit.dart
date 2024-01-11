import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/features/exercises/logic/states/exercise_state.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';

class ExerciseCubit extends Cubit<ExerciseState> {
  ExerciseCubit() : super(UninitializedExercises());

  Future<void> loadExercises() async {
    try {
      emit(LoadingExercises());

      String filePath = 'assets/exercises.csv';
      final file = File(filePath);
      if (!await file.exists()) {
        emit(ErrorExercises('CSV file not found in: $filePath'));
      }

      final lines = await file.readAsLines();
      final headers = lines[0].split(',');

      final List<Exercise> exercises = [];

      for (int i = 1; i < lines.length; i++) {
        final values = lines[i].split(',');
        final Map<String, dynamic> exercise = {};

        for (int j = 0; j < headers.length; j++) {
          exercise[headers[j]] = values[j];
        }

        exercises.add(Exercise.fromCSV(exercise));
      }

      emit(LoadedExercises(exercises));
    } catch (error, stackTrace) {
      emit(ErrorExercises('Error: $error\nStackTrace: $stackTrace'));
    }
  }
}
