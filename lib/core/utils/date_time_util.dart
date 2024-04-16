class DateTimeUtil {
  ///  example: 2024.03.04
  static String dateToString(DateTime? date) {
    if (date == null) {
      return '';
    }

    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    return '${date.year}.$month.$day';
  }

  // todo remove
  static DateTime TESTstringToDate(String stringDate) {
    return DateTime.parse(stringDate.replaceAll('.', '-'));
  }

  ///  example: 2024.12.02 16:01
  static String dateToStringWithHour(DateTime? date, bool is24HourFormat) {
    if (date == null) {
      return '';
    }

    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');

    if (!is24HourFormat) {
      if (date.hour >= 12) {
        hour = (date.hour - 12).toString().padLeft(2, '0');
        hour = hour == '00' ? '12' : hour;
        minute += ' PM';
      } else {
        minute += ' AM';
      }
    }

    return '${date.year}.$month.$day · $hour:$minute';
  }

  ///  example: 16:21
  static String secondsToDigitalFormat(int? seconds) {
    if (seconds == null) {
      return '';
    }

    final hours = seconds ~/ 3600;
    final minutes = (seconds ~/ 60) % 60;
    final remainingSeconds = seconds % 60;

    String hoursStr = (hours > 0) ? '${hours.toString().padLeft(2, '0')}:' : '';
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr:$secondsStr';
  }

  ///  example: 1 hour 23 minutes
  static String secondsToTextTime(num seconds) {
    if (seconds < 60) {
      return '> 1 minutes';
    }

    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;

    List<String> parts = [];

    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'hour' : 'hours'}');
    }

    if (minutes > 0) {
      parts.add('$minutes ${minutes == 1 ? 'minute' : 'minutes'}');
    }

    return parts.join(' ');
  }

  static bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) {
      return false;
    }

    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  static bool isBetweenDays(DateTime? date, DateTime? weekStart, DateTime? weekEnd) {
    if (date == null || weekStart == null || weekEnd == null) {
      return false;
    }

    return (date.isAfter(weekStart) || date.isAtSameMomentAs(weekStart)) && (date.isBefore(weekEnd) || date.isAtSameMomentAs(weekEnd));
  }

  static bool isBetweenMonths(DateTime? date, DateTime? monthStart, DateTime? monthEnd) {
    if (date == null || monthStart == null || monthEnd == null) {
      return false;
    }

    return (date.isAfter(monthStart) || date.isAtSameMomentAs(monthStart)) &&
        (date.isBefore(monthEnd.add(const Duration(days: 1))) || date.isAtSameMomentAs(monthEnd));
  }

  static List<DateTime> getLastWeek() {
    List<DateTime> lastWeek = [];

    for (int i = 1; i <= 7; i++) {
      DateTime currentDate = DateTime.now().subtract(Duration(days: i));
      lastWeek.add(currentDate);
    }

    return lastWeek;
  }

  static List<DateTime> getLastMonth() {
    List<DateTime> lastMonth = [];

    for (int i = 1; i <= 30; i++) {
      DateTime currentDate = DateTime.now().subtract(Duration(days: i));
      lastMonth.add(currentDate);
    }

    return lastMonth;
  }

  static List<DateTime> getLastYear() {
    List<DateTime> lastYear = [];

    for (int i = 1; i <= 365; i++) {
      DateTime currentDate = DateTime.now().subtract(Duration(days: i));
      lastYear.add(currentDate);
    }

    return lastYear;
  }
}
