import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/globals/component_functions.dart';
import 'package:training_partner/core/resources/widgets/custom_title_button.dart';
import 'package:training_partner/core/resources/widgets/custom_toast.dart';
import 'package:training_partner/features/exercises/models/movement.dart';
import 'package:training_partner/features/statistics/components/widgets/chart_creator_bottom_sheet.dart';
import 'package:training_partner/features/statistics/components/widgets/statistics_chart.dart';
import 'package:training_partner/features/statistics/logic/cubits/chart_builder_cubit.dart';
import 'package:training_partner/features/statistics/logic/cubits/statistics_cubit.dart';
import 'package:training_partner/features/statistics/logic/states/statistics_state.dart';
import 'package:training_partner/features/statistics/models/chart.dart';
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
  void initState() {
    super.initState();
    context.read<StatisticsCubit>().loadAllCharts();
  }

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
            child: Text(state.message, style: boldNormalGrey),
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
              const Icon(FontAwesomeIcons.personRunning, size: 85, color: Colors.black38),
              const SizedBox(height: 10),
              const Text("You haven't completed any workout yet, let's start one!", style: boldNormalGrey),
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
                const Icon(FontAwesomeIcons.chartPie, size: 85, color: Colors.black38),
                const SizedBox(height: 20),
                const Text("You don't have any charts yet, add one!", style: boldNormalGrey),
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
