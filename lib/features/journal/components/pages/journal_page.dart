import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/journal/components/pages/journal_entry_page.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class JournalPage extends StatelessWidget {
  final List<Movement> movements;
  final List<WorkoutSession> sessions;
  final PageController pageController;

  const JournalPage({
    super.key,
    required this.movements,
    required this.sessions,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _getHeader(),
          const SizedBox(height: 20),
          _getBodyContent(context),
        ],
      ),
    );
  }

  // todo no entry layout egységesítés
  Widget _getBodyContent(BuildContext context) {
    if (sessions.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.personRunning, size: 85, color: Colors.black38),
              const SizedBox(height: 10),
              const Text("You haven't completed any workout yet, let's start one!", style: boldNormalGrey),
              const SizedBox(height: 20),
              CustomTitleButton(
                icon: FontAwesomeIcons.play,
                label: 'Start a new workout',
                onTap: () {
                  if (pageController.hasClients) {
                    pageController.animateToPage(0, duration: const Duration(milliseconds: 750), curve: Curves.ease);
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    sessions.sort((a, b) => b.date!.compareTo(a.date!));
    return Expanded(
      child: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              if (index != sessions.length - 1)
                Positioned(
                  left: 132.5,
                  top: 50,
                  child: Container(height: 80, width: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary)),
                ),
              if (index != 0)
                Positioned(
                  left: 132.5,
                  bottom: 50,
                  child: Container(height: 80, width: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary)),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _getDateWidget(sessions[index]),
                  const SizedBox(width: 15),
                  _getTimeLineNode(context),
                  const SizedBox(width: 20),
                  _getJournalEntry(context, sessions, sessions[index]),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _getHeader() {
    return const Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('Journal', style: boldLargeBlack),
          ),
        ],
      ),
    );
  }

  Widget _getDateWidget(WorkoutSession session) {
    String day = session.date!.day.toString().padLeft(2, '0');

    return SizedBox(
      width: 110,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.calendar5, color: Colors.black38),
          const SizedBox(width: 15),
          Column(
            children: [
              Text('${session.date!.year}.', style: smallGrey),
              Text('${_getMonthName(session.date!)} $day.', style: smallGrey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getTimeLineNode(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.fromBorderSide(
          BorderSide(color: Theme.of(context).colorScheme.tertiary, width: 4),
        ),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _getJournalEntry(BuildContext context, List<WorkoutSession> sessions, WorkoutSession session) {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Card(
            elevation: 0,
            shape: defaultCornerShape,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => JournalEntryPage(
                    currentSession: session,
                    previousSession: _getPreviousSession(sessions, session),
                    movements: movements,
                    pageController: pageController,
                  ),
                ),
              ),
              borderRadius: defaultBorderRadius,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.chevron_right_rounded, size: 15, color: Colors.transparent),
                        Text(session.name, style: normalBlack, overflow: TextOverflow.ellipsis),
                        const Icon(Icons.chevron_right_rounded, size: 15),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // todo esetleg progress inkább?
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${session.exercises.length} exercise', style: smallWhite),
                                ],
                              ),
                            ),
                            const CustomDivider(isVertical: true, indents: 0),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Iconsax.clock5, color: Colors.white, size: 20),
                                  const SizedBox(width: 5),
                                  Text(DateTimeUtil.secondsToDigitalFormat(session.durationInSeconds!.toInt()), style: smallWhite),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(DateTime date) {
    switch (date.month) {
      case 1:
        return 'jan';
      case 2:
        return 'feb';
      case 3:
        return 'mar';
      case 4:
        return 'apr';
      case 5:
        return 'may';
      case 6:
        return 'jun';
      case 7:
        return 'jul';
      case 8:
        return 'aug';
      case 9:
        return 'sep';
      case 10:
        return 'oct';
      case 11:
        return 'nov';
      case 12:
        return 'dec';
      default:
        return '';
    }
  }

  WorkoutSession? _getPreviousSession(List<WorkoutSession> sessions, WorkoutSession currentSession) {
    WorkoutSession? previousSession;

    for (var session in sessions) {
      if (session.id == currentSession.id && session.date!.isBefore(currentSession.date!)) {
        if (previousSession == null || session.date!.isAfter(previousSession.date!)) {
          previousSession = session;
        }
      }
    }

    return previousSession;
  }
}
