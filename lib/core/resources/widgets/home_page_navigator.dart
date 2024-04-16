import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_bloc_builder/builders/multi_bloc_builder.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/colored_safe_area_body.dart';
import 'package:training_partner/core/resources/widgets/custom_navigation_bar.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_type_page.dart';
import 'package:training_partner/features/exercises/logic/cubits/movement_cubit.dart';
import 'package:training_partner/features/home/components/pages/home_page.dart';
import 'package:training_partner/features/journal/components/pages/journal_page.dart';
import 'package:training_partner/features/login/components/widgets/login_signup_navigator.dart';
import 'package:training_partner/features/settings/logic/cubits/settings_cubit.dart';
import 'package:training_partner/features/settings/logic/states/settings_state.dart';
import 'package:training_partner/features/statistics/components/pages/statistics_page.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/workout/logic/states/workout_state.dart';
import 'package:wakelock/wakelock.dart';

import '../../../features/exercises/logic/states/movement_state.dart';

class HomePageNavigator extends StatefulWidget {
  const HomePageNavigator({super.key});

  @override
  State createState() => _HomePageNavigatorState();
}

class _HomePageNavigatorState extends State<HomePageNavigator> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    context.read<WorkoutCubit>().getAllPreviousWorkouts();
    context.read<MovementCubit>().loadMovements();
    context.read<SettingsCubit>().getSettings();

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _getAuthenticatedBody();
        } else {
          return const LoginSignupNavigator();
        }
      },
    );
  }

  Widget _getAuthenticatedBody() {
    return MultiBlocBuilder(
      blocs: [
        context.watch<WorkoutCubit>(),
        context.watch<MovementCubit>(),
        context.watch<SettingsCubit>(),
      ],
      builder: (context, states) {
        WorkoutState workoutState = states[0];
        MovementState movementState = states[1];
        SettingsState settingsState = states[2];

        late Widget body;

        if (workoutState is WorkoutUninitialized ||
            movementState is MovementsUninitialized ||
            settingsState is SettingsUninitialized ||
            workoutState is WorkoutLoading ||
            movementState is MovementsLoading ||
            settingsState is SettingsLoading) {
          body = Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary));
        } else if (workoutState is WorkoutError || movementState is MovementsError || settingsState is SettingsError) {
          String errorMessage = '';
          if (workoutState is WorkoutError) {
            errorMessage = workoutState.errorMessage;
          } else if (movementState is MovementsError) {
            errorMessage = movementState.errorMessage;
          } else if (settingsState is SettingsError) {
            errorMessage = settingsState.message;
          }

          body = Expanded(child: Center(child: Text(errorMessage, style: CustomTextStyle.bodyPrimary(context))));
        } else if (workoutState is WorkoutSessionsLoaded && movementState is MovementsLoaded && settingsState is SettingsLoaded) {
          var pages = [
            HomePage(
              movements: movementState.movements,
              previousSessions: workoutState.sessions,
              settings: settingsState.settings,
            ),
            StatisticsPage(
              previousSessions: workoutState.sessions,
              pageController: _pageController,
              movements: movementState.movements,
              settings: settingsState.settings,
            ),
            JournalPage(
              movements: movementState.movements,
              pageController: _pageController,
              sessions: workoutState.sessions,
              settings: settingsState.settings,
            ),
            ExerciseTypePage(movements: movementState.movements),
          ];

          if (settingsState.settings.isSleepPrevented) {
            Wakelock.enable();
          } else {
            Wakelock.disable();
          }

          body = PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return pages[index];
            },
          );
        } else {
          throw '${UnimplementedError()} - ${workoutState.runtimeType} - ${movementState.runtimeType} - ${settingsState.runtimeType}';
        }

        return Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _selectedIndex, onTap: onItemTapped),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: ColoredSafeAreaBody(
            safeAreaColor: Theme.of(context).colorScheme.background,
            isLightTheme: Theme.of(context).brightness == Brightness.light,
            child: body,
          ),
        );
      },
      buildWhen: (previousStates, currentStates) {
        for (int i = 0; i < previousStates.length; i++) {
          if (previousStates[i] != currentStates[i]) {
            return true;
          }
        }

        return false;
      },
    );
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
