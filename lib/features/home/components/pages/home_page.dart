import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/home/components/widgets/profile_widget.dart';
import 'package:training_partner/features/home/components/widgets/week_view_widget.dart';
import 'package:training_partner/features/home/components/widgets/workout_widget.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/workout_editor/logic/cubits/workout_plan_cubit.dart';
import 'package:training_partner/features/workout_editor/logic/states/workout_plan_states.dart';
import 'package:training_partner/features/workout_editor/models/workout_plan.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class HomePage extends StatefulWidget {
  final List<Movement> movements;
  final List<WorkoutSession> previousSessions;
  final AppSettings settings;

  const HomePage({
    super.key,
    required this.movements,
    required this.previousSessions,
    required this.settings,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WorkoutPlan? selectedWorkoutPlan;
  final User _user = AuthService().currentUser!;
  late WorkoutPlanCubit workoutCubit;

  @override
  void initState() {
    super.initState();

    workoutCubit = context.read<WorkoutPlanCubit>();

    workoutCubit.getAllWorkoutPlan();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileWidget(user: _user, settings: widget.settings),
            const SizedBox(height: 25),
            const WeekViewWidget(),
            const SizedBox(height: 20),
            _getWorkoutWidget(),
          ],
        ),
      ),
    );
  }

  Widget _getWorkoutWidget() {
    return BlocConsumer<WorkoutPlanCubit, WorkoutPlanState>(listener: (context, state) {
      if (state is WorkoutPlanCreationSuccessful || state is WorkoutPlanDeleteSuccessful) {
        workoutCubit.getAllWorkoutPlan();
      }
    }, builder: (context, state) {
      if (state is WorkoutPlansLoading ||
          state is WorkoutPlansUninitialized ||
          state is WorkoutPlanCreationLoading ||
          state is WorkoutPlanDeleteLoading) {
        return const CircularProgressIndicator();
      }
      if (state is WorkoutPlansError) {
        return Center(child: Text(state.message));
      }
      if (state is WorkoutPlanCreationError) {
        return Center(child: Text(state.message));
      }
      if (state is WorkoutPlanDeleteError) {
        return Center(child: Text(state.message));
      }
      if (state is WorkoutPlansLoaded) {
        return WorkoutWidget(
          workoutPlans: state.workoutPlans,
          previousSessions: widget.previousSessions,
          selectedWorkoutPlan: selectedWorkoutPlan ?? state.workoutPlans.firstOrNull,
          movements: widget.movements,
          onSelect: (plan) {
            setState(() {
              selectedWorkoutPlan = plan;
            });
          },
          settings: widget.settings,
        );
      }

      return Container(
        color: Colors.red,
        child: Text(state.toString()),
      );
    });
  }
}
