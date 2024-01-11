import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/resources/firebase/firebase_options.dart';
import 'package:training_partner/core/resources/widgets/home_page_navigator.dart';
import 'package:training_partner/features/exercises/logic/cubits/exercise_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TrainingPartner());
}

class TrainingPartner extends StatelessWidget {
  const TrainingPartner({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _getBlocProviders(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePageNavigator(),
      ),
    );
  }

  List<BlocProvider> _getBlocProviders() {
    return [
      BlocProvider<ExerciseCubit>(create: (context) => ExerciseCubit()),
    ];
  }
}
