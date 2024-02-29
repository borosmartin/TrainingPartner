import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/resources/widgets/divider_with_text.dart';
import 'package:training_partner/core/utils/text_util.dart';

class WeekViewWidget extends StatelessWidget {
  const WeekViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DividerWithText(text: _getMonthName(), textStyle: normalGrey),
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

    for (var date in getThisWeekDays()) {
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
        return TextUtil.getCustomTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        );
      } else if (date.isAfter(now)) {
        return TextUtil.getCustomTextStyle(
          fontSize: 16,
          color: Colors.black,
        );
      } else if (date.isBefore(now)) {
        return TextUtil.getCustomTextStyle(
          fontSize: 16,
          color: Colors.black54,
        );
      }
    } else {
      if (date.day == now.day) {
        return TextUtil.getCustomTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        );
      } else if (date.isAfter(now)) {
        return TextUtil.getCustomTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        );
      } else if (date.isBefore(now)) {
        return TextUtil.getCustomTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        );
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

  List<DateTime> getThisWeekDays() {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    List<DateTime> weekDays = [];
    for (int i = 0; i < 7; i++) {
      weekDays.add(monday.add(Duration(days: i)));
    }

    return weekDays;
  }
}
