import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/globals.dart';
import 'package:training_partner/core/resources/gpt/gpt_message.dart';
import 'package:training_partner/core/resources/gpt/gpt_repository.dart';
import 'package:training_partner/core/resources/gpt/gpt_state.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class GptCubit extends Cubit<GptState> {
  final GptRepository _gptRepository;

  GptCubit(this._gptRepository) : super(GptUninitializedState());

  Future<void> getGptResponse(WorkoutPlan workoutPlan, List<GptMessage> messages) async {
    try {
      emit(GptResponseLoading());

      GptMessage? response = await _gptRepository.getGptResponse(currentUser.email!, workoutPlan, messages);

      if (response == null) {
        emit(const GptResponseError(message: 'Error: GPT service is not available'));
      }

      emit(GptResponseLoaded(message: response!));
    } catch (error, stackTrace) {
      emit(GptResponseError(message: 'Error: $error, stackTrace: $stackTrace'));
    }
  }
}
