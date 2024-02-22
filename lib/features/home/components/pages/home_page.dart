import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/features/home/components/widgets/home_widgets/profile_widget.dart';
import 'package:training_partner/features/home/components/widgets/home_widgets/week_view_widget.dart';
import 'package:training_partner/features/home/components/widgets/home_widgets/workout_widget.dart';
import 'package:training_partner/features/home/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/home/logic/states/workout_states.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WorkoutPlan? selectedWorkoutPlan;
  final User _user = AuthService().currentUser!;
  late WorkoutCubit workoutCubit;

  @override
  void initState() {
    super.initState();

    workoutCubit = context.read<WorkoutCubit>();

    workoutCubit.getAllWorkoutPlan();
  }

  // todo singlechildscrollview?
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileWidget(user: _user),
          const SizedBox(height: 20),
          const WeekViewWidget(),
          const SizedBox(height: 20),
          _getWorkoutWidget(),
        ],
      ),
    );
  }

  Widget _getWorkoutWidget() {
    return BlocConsumer<WorkoutCubit, WorkoutState>(listener: (context, state) {
      if (state is WorkoutPlanCreationSuccessful || state is WorkoutPlanDeleteSuccessful) {
        workoutCubit.getAllWorkoutPlan();
      }
    }, builder: (context, state) {
      if (state is WorkoutPlansLoading ||
          state is WorkoutsUninitialized ||
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
          selectedWorkoutPlan: selectedWorkoutPlan ?? state.workoutPlans.firstOrNull,
          onSelect: (plan) {
            setState(() {
              selectedWorkoutPlan = plan;
            });
          },
        );
      }

      return Container(
        color: Colors.red,
        child: Text(state.toString()),
      );
    });
  }
}
