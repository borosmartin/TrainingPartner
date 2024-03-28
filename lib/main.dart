import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/config/themes/light_theme.dart';
import 'package:training_partner/core/resources/firebase/firebase_options.dart';
import 'package:training_partner/core/resources/open_ai/gpt_cubit.dart';
import 'package:training_partner/core/resources/open_ai/gpt_repository.dart';
import 'package:training_partner/core/resources/open_ai/gpt_service.dart';
import 'package:training_partner/core/resources/widgets/home_page_navigator.dart';
import 'package:training_partner/features/exercises/data/repository/exercise_repository.dart';
import 'package:training_partner/features/exercises/data/service/exercise_local_service.dart';
import 'package:training_partner/features/exercises/data/service/exercise_service.dart';
import 'package:training_partner/features/exercises/logic/cubits/movement_cubit.dart';
import 'package:training_partner/features/login/logic/cubits/login_cubit.dart';
import 'package:training_partner/features/statistics/data/repository/statistics_repository.dart';
import 'package:training_partner/features/statistics/data/service/statistics_local_service.dart';
import 'package:training_partner/features/statistics/logic/cubits/chart_builder_cubit.dart';
import 'package:training_partner/features/statistics/logic/cubits/statistics_cubit.dart';
import 'package:training_partner/features/workout/data/repository/workout_repository.dart';
import 'package:training_partner/features/workout/data/service/workout_service_local.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/workout_editor/data/repository/workout_plan_repository.dart';
import 'package:training_partner/features/workout_editor/data/service/workout_plan_local_service.dart';
import 'package:training_partner/features/workout_editor/logic/cubits/workout_plan_cubit.dart';

import 'core/resources/open_ai/gpt_service_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  runApp(const TrainingPartner());
}

class TrainingPartner extends StatelessWidget {
  const TrainingPartner({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _getRepositoryProviders(),
      child: MultiBlocProvider(
        providers: _getBlocProviders(),
        child: MaterialApp(
          theme: lightTheme,
          debugShowCheckedModeBanner: false,
          home: const HomePageNavigator(),
        ),
      ),
    );
  }

  List<BlocProvider> _getBlocProviders() {
    return [
      BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(),
      ),
      BlocProvider<MovementCubit>(
        create: (context) => MovementCubit(
          RepositoryProvider.of<ExerciseRepository>(context),
        ),
      ),
      BlocProvider<WorkoutPlanCubit>(
        create: (context) => WorkoutPlanCubit(
          RepositoryProvider.of<WorkoutPlanRepository>(context),
        ),
      ),
      BlocProvider<WorkoutCubit>(
        create: (context) => WorkoutCubit(
          RepositoryProvider.of<WorkoutRepository>(context),
        ),
      ),
      BlocProvider<StatisticsCubit>(
        create: (context) => StatisticsCubit(
          RepositoryProvider.of<StatisticsRepository>(context),
        ),
      ),
      BlocProvider<ChartBuilderCubit>(
        create: (context) => ChartBuilderCubit(),
      ),
      BlocProvider<GptCubit>(
        create: (context) => GptCubit(
          RepositoryProvider.of<GptRepository>(context),
        ),
      ),
    ];
  }

  List<RepositoryProvider> _getRepositoryProviders() {
    return [
      RepositoryProvider<ExerciseRepository>(
        create: (context) => ExerciseRepository(
          ExerciseService(),
          ExerciseServiceLocal(),
        ),
      ),
      RepositoryProvider<WorkoutPlanRepository>(
        create: (context) => WorkoutPlanRepository(
          WorkoutPlanServiceLocal(),
        ),
      ),
      RepositoryProvider<WorkoutRepository>(
        create: (context) => WorkoutRepository(
          WorkoutServiceLocal(),
        ),
      ),
      RepositoryProvider<StatisticsRepository>(
        create: (context) => StatisticsRepository(
          StatisticsLocalService(),
        ),
      ),
      RepositoryProvider<GptRepository>(
        create: (context) => GptRepository(
          GptService(),
          GptServiceLocal(),
        ),
      ),
    ];
  }
}
