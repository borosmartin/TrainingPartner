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

  ///  example: 2024.12.02 16:21
  static String dateToStringWithHour(DateTime? date) {
    if (date == null) {
      return '';
    }
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    return '${date.year}.$month.$day ${date.hour}:${date.minute}';
  }
}
