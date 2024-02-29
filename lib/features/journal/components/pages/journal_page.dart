import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_divider.dart';
import 'package:training_partner/core/utils/text_util.dart';
import 'package:training_partner/features/workout/logic/cubits/workout_cubit.dart';
import 'package:training_partner/features/workout/logic/states/workout_state.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutCubit>().getAllWorkoutSession();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _getHeader(),
          const SizedBox(height: 20),
          _getBodyContent(),
        ],
      ),
    );
  }

  Widget _getBodyContent() {
    return BlocBuilder<WorkoutCubit, WorkoutState>(
      builder: (context, state) {
        if (state is WorkoutLoading || state is WorkoutUninitialized) {
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is WorkoutError) {
          return Expanded(
            child: Center(
              child: Text(state.message),
            ),
          );
        } else if (state is WorkoutSessionsLoaded) {
          var sessions = state.sessions;

          sessions.sort((a, b) => b.date!.compareTo(a.date!));

          return Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    if (index != sessions.length - 1)
                      Positioned(
                        left: 112.5,
                        top: 50,
                        child: Container(height: 80, width: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary)),
                      ),
                    if (index != 0)
                      Positioned(
                        left: 112.5,
                        bottom: 50,
                        child: Container(height: 80, width: 4, decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary)),
                      ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _getDateWidget(sessions[index]),
                        const SizedBox(width: 20),
                        _getTimeLineNode(),
                        const SizedBox(width: 20),
                        _getJournalEntry(sessions[index]),
                      ],
                    ),
                  ],
                );
              },
            ),
          );
        }

        throw UnimplementedError();
      },
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
      width: 85,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.calendar5, color: Colors.black38),
          const SizedBox(width: 10),
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

  Widget _getTimeLineNode() {
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

  Widget _getJournalEntry(WorkoutSession session) {
    return Expanded(
      child: SizedBox(
        height: 95,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Card(
            elevation: 0,
            shape: defaultCornerShape,
            margin: EdgeInsets.zero,
            child: InkWell(
              //todo
              onTap: () {},
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
                                  Text(TextUtil.formatTimeToDigitalFormat(session.durationInSeconds!.toInt()), style: smallWhite),
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
}
