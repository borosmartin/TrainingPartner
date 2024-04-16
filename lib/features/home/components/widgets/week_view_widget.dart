import 'package:flutter/material.dart';
import 'package:training_partner/config/theme/custom_text_theme.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class WeekViewWidget extends StatelessWidget {
  const WeekViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          shape: defaultCornerShape,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _getWeekDayWidgets(context),
          ),
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
        color: date.day == DateTime.now().day ? accentColor : null,
        shape: defaultCornerShape,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Text(date.day.toString(), style: _getTextStyle(context, date, false)),
              Text(_getDayName(date), style: _getTextStyle(context, date, true)),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context, DateTime date, bool isName) {
    DateTime now = DateTime.now();

    if (isName) {
      if (date.day == now.day) {
        return CustomTextStyle.bodySmallTetriary(context, weight: FontWeight.w500);
      } else if (date.isAfter(now)) {
        return CustomTextStyle.bodySmallPrimary(context, weight: FontWeight.w400);
      } else if (date.isBefore(now)) {
        return CustomTextStyle.bodySmallSecondary(context, weight: FontWeight.w400);
      }
    } else {
      if (date.day == now.day) {
        return CustomTextStyle.bodySmallTetriary(context, weight: FontWeight.w600);
      } else if (date.isAfter(now)) {
        return CustomTextStyle.bodySmallPrimary(context, weight: FontWeight.w600);
      } else if (date.isBefore(now)) {
        return CustomTextStyle.bodySmallSecondary(context, weight: FontWeight.w600);
      }
    }
    return CustomTextStyle.subtitlePrimary(context);
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
