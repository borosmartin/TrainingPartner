import 'package:training_partner/core/resources/gpt/gpt_message.dart';
import 'package:training_partner/core/resources/gpt/gpt_service.dart';
import 'package:training_partner/core/resources/gpt/gpt_service_local.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';

class GptRepository {
  GptService gptService;
  GptServiceLocal gptServiceLocal;

  GptRepository(this.gptService, this.gptServiceLocal);

  Future<GptMessage?> getGptResponse(String email, WorkoutPlan workoutPlan, List<GptMessage> messages) async {
    try {
      GptMessage response = await gptService.getGptResponse(messages);
      saveWorkoutTip(email, workoutPlan, response);

      return response;
    } catch (error) {
      try {
        return await getGptTipFromHive(email, workoutPlan);
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> saveWorkoutTip(String email, WorkoutPlan workoutPlan, GptMessage message) async {
    await gptServiceLocal.saveWorkoutTip(email, workoutPlan, message);
  }

  Future<GptMessage?> getGptTipFromHive(String email, WorkoutPlan workoutPlan) async {
    return await gptServiceLocal.getGptTipFromHive(email, workoutPlan);
  }

  Future<void> deleteAllGptTipFromHive(String email) async {
    await gptServiceLocal.deleteAllGptTipFromHive(email);
  }
}
