import 'package:equatable/equatable.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class WorkoutPlan extends Equatable {
  final String name;
  final List<WorkoutSession> sessions;
  final bool isActive;

  const WorkoutPlan({required this.name, required this.sessions, this.isActive = false});

  factory WorkoutPlan.fromJson(Map json) {
    List<WorkoutSession> sessions = (json['sessions'] as List).map((sessionJson) => WorkoutSession.fromJson(sessionJson)).toList();

    return WorkoutPlan(
      name: json['name'],
      sessions: sessions,
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'name': name,
      'isActive': isActive,
      'sessions': sessions.map((session) => session.toJson()).toList(),
    };

    return json;
  }

  WorkoutPlan copyWith({
    String? name,
    List<WorkoutSession>? sessions,
    bool? isActive,
  }) {
    return WorkoutPlan(
      name: name ?? this.name,
      sessions: sessions ?? this.sessions,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [name, sessions];
}
