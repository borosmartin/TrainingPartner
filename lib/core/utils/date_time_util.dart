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

  ///  example: 2024.12.02 16:01
  static String dateToStringWithHour(DateTime? date) {
    if (date == null) {
      return '';
    }
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');

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
}
