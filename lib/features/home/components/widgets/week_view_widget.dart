import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';

class WeekViewWidget extends StatelessWidget {
  const WeekViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: DividerWithText(text: _getMonthName(), textStyle: normalGrey),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getWeekDayWidgets(context),
        ),
      ],
    );
  }

  List<Widget> _getWeekDayWidgets(BuildContext context) {
    List<Widget> days = [];

    for (var date in _getWeekDays()) {
      days.add(_getDayWidget(context, date));
    }

    return days;
  }

  Widget _getDayWidget(BuildContext context, DateTime date) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: date.day == DateTime.now().day ? Theme.of(context).colorScheme.tertiary : Colors.white,
        shape: defaultCornerShape,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Text(date.day.toString(), style: _getTextStyle(date, false)),
              Text(_getDayName(date), style: _getTextStyle(date, true)),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _getTextStyle(DateTime date, bool isName) {
    DateTime now = DateTime.now();

    if (isName) {
      if (date.day == now.day) {
        return boldNormalWhite;
      } else if (date.isAfter(now)) {
        return boldNormalBlack;
      } else if (date.isBefore(now)) {
        return boldNormalGrey;
      }
    } else {
      if (date.day == now.day) {
        return boldNormalWhite;
      } else if (date.isAfter(now)) {
        return normalBlack;
      } else if (date.isBefore(now)) {
        return normalGrey;
      }
    }
    return boldNormalBlack;
  }

  String _getDayName(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonthName() {
    DateTime now = DateTime.now();

    switch (now.month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  List<DateTime> _getWeekDays() {
    DateTime now = DateTime.now();

    return [
      now.add(const Duration(days: -3)),
      now.add(const Duration(days: -2)),
      now.add(const Duration(days: -1)),
      now,
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 2)),
      now.add(const Duration(days: 3)),
    ];
  }
}
