import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/custom_navigation_bar.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/features/exercises/components/pages/exercise_type_page.dart';
import 'package:training_partner/features/exercises/logic/cubits/movement_cubit.dart';
import 'package:training_partner/features/home/components/pages/home_page.dart';
import 'package:training_partner/features/journal/components/pages/journal_page.dart';
import 'package:training_partner/features/login/components/widgets/login_signup_navigator.dart';
import 'package:training_partner/features/statistics/components/pages/statistics_page.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/workout/logic/states/workout_state.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

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

    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    colorSafeArea(color: Theme.of(context).colorScheme.background);

    // todo közös cubit?
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BlocConsumer<WorkoutCubit, WorkoutState>(
            listener: (BuildContext context, WorkoutState state) {
              if (state is WorkoutDeleted) {
                showBottomToast(
                  context: context,
                  message: 'Workout deleted!',
                  type: ToastType.success,
                );
              } else if (state is WorkoutSaved) {
                showBottomToast(
                  context: context,
                  message: 'Workout completed!',
                  type: ToastType.success,
                );
              }
            },
            builder: (context, workoutState) {
              Widget body = Container();

              if (workoutState is WorkoutLoading || workoutState is WorkoutUninitialized) {
                body = Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary));
              } else if (workoutState is WorkoutError) {
                body = Expanded(child: Center(child: Text(workoutState.errorMessage)));
              } else if (workoutState is WorkoutSessionsLoaded || workoutState is WorkoutSaved || workoutState is WorkoutDeleted) {
                List<WorkoutSession> sessions = [];
                if (workoutState is WorkoutSessionsLoaded) {
                  sessions = workoutState.sessions;
                } else if (workoutState is WorkoutSaved) {
                  sessions = workoutState.sessions;
                } else if (workoutState is WorkoutDeleted) {
                  sessions = workoutState.sessions;
                }

                return BlocBuilder<MovementCubit, MovementState>(
                  builder: (context, movementState) {
                    if (movementState is MovementsLoading || movementState is MovementsUninitialized) {
                      body = Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary));
                    } else if (movementState is MovementsError) {
                      body = Expanded(child: Center(child: Text(movementState.errorMessage)));
                    } else if (movementState is MovementsLoaded) {
                      var pages = [
                        HomePage(
                          movements: movementState.movements,
                          previousSessions: sessions,
                        ),
                        StatisticsPage(
                          previousSessions: sessions,
                          pageController: _pageController,
                          movements: movementState.movements,
                        ),
                        JournalPage(
                          movements: movementState.movements,
                          pageController: _pageController,
                          sessions: sessions,
                        ),
                        ExerciseTypePage(movements: movementState.movements),
                      ];

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
                      throw '${UnimplementedError()} - ${movementState.runtimeType}';
                    }

                    return SafeArea(
                      child: Scaffold(
                        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _selectedIndex, onTap: onItemTapped),
                        body: body,
                      ),
                    );
                  },
                );
              } else {
                throw '${UnimplementedError()} - ${workoutState.runtimeType}';
              }

              return SafeArea(
                child: Scaffold(
                  body: body,
                ),
              );
            },
          );
        } else {
          return const LoginSignupNavigator();
        }
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
