import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/settings/model/app_settings.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_bottom_sheet.dart';
import 'package:training_partner/features/statistics/components/widgets/statistics_chart.dart';
import 'package:training_partner/features/statistics/logic/cubits/statistics_cubit.dart';
import 'package:training_partner/features/statistics/logic/states/statistics_state.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
import 'package:training_partner/features/workout_editor/models/workout_session.dart';

class StatisticsPage extends StatefulWidget {
  final List<WorkoutSession> previousSessions;
  final PageController pageController;
  final List<Movement> movements;
  final AppSettings settings;

  const StatisticsPage({
    super.key,
    required this.previousSessions,
    required this.pageController,
    required this.movements,
    required this.settings,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  void initState() {
    super.initState();
    context.read<StatisticsCubit>().loadAllCharts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              _getBodyContent(),
            ],
          ),
          Positioned(
            bottom: 15,
            right: 0,
            child: FloatingActionButton(
              shape: defaultCornerShape,
              backgroundColor: accentColor,
              onPressed: () => _showChartCreatorBottomSheet(context),
              elevation: 0,
              tooltip: 'Add new chart',
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // todo Error states widget
  Widget _getBodyContent() {
    return BlocConsumer<StatisticsCubit, StatisticsState>(listener: (context, state) {
      if (state is ChartAddSuccess) {
        showBottomToast(context: context, message: 'Chart added successfully!', type: ToastType.success);
        context.read<StatisticsCubit>().loadAllCharts();
      } else if (state is ChartDeleteSuccess) {
        showBottomToast(context: context, message: 'Chart removed successfully!', type: ToastType.success);
        context.read<StatisticsCubit>().loadAllCharts();
      }
    }, builder: (context, state) {
      if (state is ChartsLoading || state is StatisticsUninitialized || state is ChartDeleteSuccess) {
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(color: Theme.of(context).colorScheme.tertiary),
          ),
        );
      } else if (state is StatisticsError) {
        return Expanded(
          child: Center(
            child: Text(state.message, style: CustomTextStyle.subtitleTetriary(context)),
          ),
        );
      } else if (state is ChartsLoaded) {
        return _getChartList(state.charts);
      } else {
        throw '${UnimplementedError()} - ${state.runtimeType}';
      }
    });
  }

  Widget _getChartList(List<Chart> charts) {
    if (widget.previousSessions.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.personRunning, size: 85, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 10),
              Text("You haven't completed any workout yet, let's start one!", style: CustomTextStyle.subtitleSecondary(context)),
              const SizedBox(height: 20),
              CustomTitleButton(
                icon: FontAwesomeIcons.play,
                label: 'Start a new workout',
                onTap: () {
                  if (widget.pageController.hasClients) {
                    widget.pageController.animateToPage(0, duration: const Duration(milliseconds: 750), curve: Curves.ease);
                  }
                },
              ),
            ],
          ),
        ),
      );
    } else {
      if (charts.isEmpty) {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FontAwesomeIcons.chartPie, size: 85, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 20),
                Text("You don't have any charts yet, add one!", style: CustomTextStyle.subtitleSecondary(context)),
                const SizedBox(height: 20),
                CustomTitleButton(
                  icon: FontAwesomeIcons.plus,
                  label: 'Create new chart',
                  onTap: () => _showChartCreatorBottomSheet(context),
                ),
              ],
            ),
          ),
        );
      } else {
        return Expanded(
          child: ListView.builder(
            itemCount: charts.length,
            itemBuilder: (context, index) {
              return StatisticsChart(
                key: GlobalKey(),
                index: index,
                chart: charts[index],
                previousSessions: widget.previousSessions,
                movements: widget.movements,
                settings: widget.settings,
              );
            },
          ),
        );
      }
    }
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
