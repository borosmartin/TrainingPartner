import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/config/themes/light_theme.dart';
import 'package:training_partner/core/resources/firebase/firebase_options.dart';
import 'package:training_partner/core/resources/widgets/home_page_navigator.dart';
import 'package:training_partner/features/exercises/data/repository/exercise_repository.dart';
import 'package:training_partner/features/exercises/data/service/exercise_local_service.dart';
import 'package:training_partner/features/exercises/data/service/exercise_service.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';
import 'package:training_partner/features/home/data/repository/workout_repository.dart';
import 'package:training_partner/features/home/data/service/workout_local_service.dart';
import 'package:training_partner/features/home/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/login/logic/cubits/login_cubit.dart';

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
      BlocProvider<ExerciseCubit>(
        create: (context) => ExerciseCubit(
          RepositoryProvider.of<ExerciseRepository>(context),
        ),
      ),
      BlocProvider<WorkoutCubit>(
        create: (context) => WorkoutCubit(
          RepositoryProvider.of<WorkoutRepository>(context),
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
      RepositoryProvider<WorkoutRepository>(
        create: (context) => WorkoutRepository(
          WorkoutServiceLocal(),
        ),
      ),
    ];
  }
}
