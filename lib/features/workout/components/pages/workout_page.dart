import 'package:flutter/material.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/features/exercises/models/exercise.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/workout/components/widgets/workout_actions_button.dart';
import 'package:training_partner/features/workout/components/widgets/workout_dropdown.dart';
import 'package:training_partner/features/workout/components/widgets/workout_exercise_list.dart';
import 'package:training_partner/features/workout/components/widgets/workout_session_row.dart';
import 'package:training_partner/features/workout/models/workout_plan.dart';
import 'package:training_partner/features/workout/models/workout_session.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  List<WorkoutPlan> mockPlans = [
    WorkoutPlan(
      name: "Plan 1",
      isActive: true,
      sessions: [
        WorkoutSession(
          name: "Push A",
          exercises: const [
            Exercise(
              movement: Movement(
                name: "Benchpress",
                id: '1',
                bodyPart: 'chest',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Incline benchpress",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Tricep pushdown",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
          ],
          date: DateTime.now(),
        ),
        WorkoutSession(
          name: "Push B",
          exercises: const [
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Pullups",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Hammer curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
          ],
          date: DateTime.now(),
        ),
        WorkoutSession(
          name: "Pull A",
          exercises: const [
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
          ],
          date: DateTime.now(),
        ),
        WorkoutSession(
          name: "Pull B",
          exercises: const [
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
          ],
          date: DateTime.now(),
        ),
      ],
    ),
    WorkoutPlan(
      name: "My workoutplan 2",
      isActive: false,
      sessions: [
        WorkoutSession(
          name: "Push",
          exercises: const [
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
          ],
          date: DateTime.now(),
        ),
        WorkoutSession(
          name: "Pull",
          exercises: const [
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
            Exercise(
              movement: Movement(
                name: "Curl",
                id: '1',
                bodyPart: 'arms',
                target: 'biceps',
                gifUrl: 'http:example.com',
                equipment: 'dumbbel',
                instructions: [
                  "1. Mock mock mock mock",
                  "2. Mock mock mock mock",
                  "3. Mock mock mock mock",
                ],
                secondaryMuscles: [],
              ),
              sets: 3,
              repetitions: 10,
            ),
          ],
          date: DateTime.now(),
        ),
      ],
    ),
  ];

  WorkoutPlan? selectedWorkoutPlan;
  WorkoutSession? selectedWorkoutSession;

  @override
  void initState() {
    super.initState();

    // todo selectedWorkoutSession

    if (mockPlans != null && mockPlans.isNotEmpty) {
      selectedWorkoutPlan = mockPlans.firstWhere((plan) => plan.isActive);
    } else {
      selectedWorkoutPlan = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                WorkoutPlanDropdown(
                    workoutPlans: mockPlans,
                    onSelect: (plan) {
                      setState(() {
                        selectedWorkoutPlan = plan;
                      });
                    }),
                WorkoutPlanActionsButton(workoutPlan: selectedWorkoutPlan),
              ],
            ),
          ),
          WorkoutSessionRow(
            workoutPlan: selectedWorkoutPlan,
            onSelect: (session) {
              setState(() {
                selectedWorkoutSession = session;
              });
            },
          ),
          const CustomDivider(padding: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 5)),
          WorkoutExerciseList(exercises: selectedWorkoutSession?.exercises ?? []),
        ],
      ),
    );
  }
}
