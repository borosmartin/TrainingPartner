import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_partner/config/themes/light_theme.dart';
import 'package:training_partner/core/resources/firebase/firebase_options.dart';
import 'package:training_partner/core/resources/widgets/home_page_navigator.dart';
import 'package:training_partner/features/exercises/data/repository/exercise_repository.dart';
import 'package:training_partner/features/exercises/data/service/exercise_local_service.dart';
import 'package:training_partner/features/exercises/data/service/exercise_service.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';
import 'package:training_partner/features/login/data/repository/login_repository.dart';
import 'package:training_partner/features/login/data/service/login_local_service.dart';
import 'package:training_partner/features/login/logic/cubits/login_cubit.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: 'dotenv.env');
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
          home: const HomePageNavigator(),
        ),
      ),
    );
  }

  List<BlocProvider> _getBlocProviders() {
    return [
      BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(
          RepositoryProvider.of<LoginRepository>(context),
        ),
      ),
      BlocProvider<ExerciseCubit>(
        create: (context) => ExerciseCubit(
          RepositoryProvider.of<ExerciseRepository>(context),
        ),
      ),
      BlocProvider<WorkoutCubit>(
        create: (context) => WorkoutCubit(),
      ),
    ];
  }

  List<RepositoryProvider> _getRepositoryProviders() {
    return [
      RepositoryProvider<LoginRepository>(
        create: (context) => LoginRepository(
          LoginLocalService(),
        ),
      ),
      RepositoryProvider<ExerciseRepository>(
        create: (context) => ExerciseRepository(
          ExerciseService(),
          ExerciseServiceLocal(),
        ),
      ),
    ];
  }
}
