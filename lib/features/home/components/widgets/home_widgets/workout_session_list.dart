import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/features/home/models/workout_session.dart';

class WorkoutSessionList extends StatelessWidget {
  final List<WorkoutSession> sessions;
  const WorkoutSessionList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: buildSessionRows(),
        ),
      ),
    );
  }

  List<Widget> buildSessionRows() {
    List<Widget> sessionRows = [];
    for (int i = 0; i < sessions.length; i++) {
      sessionRows.add(buildSessionRow(i, sessions[i]));
    }
    return sessionRows;
  }

  Widget buildSessionRow(int index, WorkoutSession session) {
    bool isFirst = index == 0;
    bool isLast = index == sessions.length - 1;

    return Container(
      height: 70,
      decoration: isLast
          ? const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ))
          : const BoxDecoration(
              color: Colors.white,
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                )
              : BorderRadius.zero,
          onTap: () {},
          child: Padding(
            padding: isFirst
                ? const EdgeInsets.only(left: 18, right: 20, top: 5, bottom: 5)
                : const EdgeInsets.only(left: 15, right: 20, top: 5, bottom: 5),
            child: Row(
              children: [
                Text((index + 1).toString(), style: boldLargeGrey),
                const SizedBox(width: 15),
                const CustomDivider(isVertical: true),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.name, style: boldNormalBlack),
                    // todo
                    const Text('Valami kis text ide', style: normalGrey),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
