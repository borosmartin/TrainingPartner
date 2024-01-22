import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/features/workout/models/workout_plan.dart';
import 'package:training_partner/features/workout/models/workout_session.dart';

class WorkoutSessionRow extends StatefulWidget {
  final WorkoutPlan? workoutPlan;
  final Function(WorkoutSession?) onSelect;

  const WorkoutSessionRow({Key? key, required this.workoutPlan, required this.onSelect}) : super(key: key);

  @override
  State<WorkoutSessionRow> createState() => _WorkoutSessionRowState();
}

class _WorkoutSessionRowState extends State<WorkoutSessionRow> {
  WorkoutSession? selectedSession;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: selectedSession != null ? _getSelectedSessionView() : _getSessionListView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSessionListView() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          height: 60,
          child: ListView.separated(
            itemCount: widget.workoutPlan?.sessions.length ?? 0,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: VerticalDivider(
                color: Colors.grey.shade300,
                width: 0,
                thickness: 1.5,
                indent: 5,
                endIndent: 5,
              ),
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final session = widget.workoutPlan!.sessions[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedSession = session;
                  });
                  widget.onSelect(session);
                },
                child: SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(session.name, style: normalBlack),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getSelectedSessionView() {
    return InkWell(
      onTap: () {
        setState(() {
          selectedSession = null;
        });
        widget.onSelect(null);
      },
      child: Card(
        elevation: 0,
        shape: defaultCornerShape,
        child: SizedBox(
          height: 60,
          child: Center(
            child: Text(selectedSession!.name, style: normalBlack),
          ),
        ),
      ),
    );
  }
}
