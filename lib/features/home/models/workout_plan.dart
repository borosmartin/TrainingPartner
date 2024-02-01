import 'package:equatable/equatable.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class WorkoutPlan extends Equatable {
  final String name;
  final List<WorkoutSession> sessions;
  final bool isActive;
  const WorkoutPlan({required this.name, required this.sessions, this.isActive = false});

  @override
  List<Object?> get props => [name, sessions];
}
