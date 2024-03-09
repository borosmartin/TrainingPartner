import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_bottom_sheet.dart';
import 'package:training_partner/features/statistics/logic/cubits/chart_builder_cubit.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class StatisticsPage extends StatefulWidget {
  final List<WorkoutSession> previousSessions;
  final PageController pageController;
  final List<Movement> movements;

  const StatisticsPage({super.key, required this.previousSessions, required this.pageController, required this.movements});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _getHeaderWidget(),
          const SizedBox(height: 20),
          _getBodyContent(),
        ],
      ),
    );
  }

  Widget _getHeaderWidget() {
    return Card(
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FontAwesomeIcons.plus, color: Colors.transparent),
          const Spacer(),
          const SizedBox(width: 30),
          const Icon(Iconsax.chart_15),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text('Statistics', style: boldLargeBlack),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.read<ChartBuilderCubit>().toFirstStage();
              _showChartCreatorBottomSheet(context);
            },
            icon: const Icon(FontAwesomeIcons.plus),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }

  Widget _getBodyContent() {
    if (widget.previousSessions.isEmpty) {
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
                onPressed: () {
                  if (widget.pageController.hasClients) {
                    widget.pageController.animateToPage(0, duration: const Duration(milliseconds: 750), curve: Curves.ease);
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    return const Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FontAwesomeIcons.chartPie, size: 85, color: Colors.black38),
              SizedBox(height: 20),
              Text("You don't have any charts yet, add one!", style: boldNormalGrey),
            ],
          ),
        ),
      ),
    );
  }

  void _showChartCreatorBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return ChartCreatorBottomSheet(
          movements: widget.movements,
        );
      },
    );
  }
}
