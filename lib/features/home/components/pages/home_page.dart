import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/firebase/auth_service.dart';
import 'package:training_partner/core/resources/widgets/custom_small_button.dart';
import 'package:training_partner/features/home/components/widgets/profile_widget.dart';
import 'package:training_partner/features/home/components/widgets/week_view_widget.dart';
import 'package:training_partner/features/home/components/widgets/workout_widget.dart';
import 'package:training_partner/features/home/models/workout_plan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<WorkoutPlan> mockPlans = [
  //   const WorkoutPlan(
  //     name: "Plan 1",
  //     isActive: true,
  //     sessions: [
  //       WorkoutSession(
  //         name: "Push A",
  //         exercises: [
  //           Exercise(
  //             movement: Movement(
  //               name: "Benchpress",
  //               id: '1',
  //               bodyPart: 'chest',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Incline benchpress",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Tricep pushdown",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //         ],
  //       ),
  //       WorkoutSession(
  //         name: "Push B",
  //         exercises: [
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Pullups",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Hammer curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //         ],
  //       ),
  //       WorkoutSession(
  //         name: "Pull A",
  //         exercises: [
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //         ],
  //       ),
  //       WorkoutSession(
  //         name: "Pull B",
  //         exercises: [
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  //   const WorkoutPlan(
  //     name: "My workoutplan 2",
  //     isActive: false,
  //     sessions: [
  //       WorkoutSession(
  //         name: "Push",
  //         exercises: [
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //         ],
  //       ),
  //       WorkoutSession(
  //         name: "Pull",
  //         exercises: [
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //           Exercise(
  //             movement: Movement(
  //               name: "Curl",
  //               id: '1',
  //               bodyPart: 'arms',
  //               target: 'biceps',
  //               gifUrl: 'http:example.com',
  //               equipment: 'dumbbel',
  //               instructions: [
  //                 "1. Mock mock mock mock",
  //                 "2. Mock mock mock mock",
  //                 "3. Mock mock mock mock",
  //               ],
  //               secondaryMuscles: [],
  //             ),
  //             sets: 3,
  //             repetitions: 10,
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  // ];

  WorkoutPlan? selectedWorkoutPlan;
  final User _user = AuthService().currentUser!;

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
          Row(
            children: [
              ProfileWidget(user: _user),
              const Spacer(),
              Column(
                children: [
                  CustomSmallButton(
                    label: 'Logout',
                    icon: const Icon(Icons.power_settings_new_rounded, color: Colors.black38),
                    onTap: _signOut,
                  ),
                  const SizedBox(height: 35),
                  CustomSmallButton(
                    label: 'Settings',
                    icon: const Icon(Icons.settings_rounded, color: Colors.black38),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          const WeekViewWidget(),
          const SizedBox(height: 15),
          WorkoutWidget(
            workoutPlans: const [],
            selectedWorkoutPlan: selectedWorkoutPlan,
            onSelect: (plan) {
              setState(() {
                selectedWorkoutPlan = plan;
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await AuthService().signOut();
  }
}
