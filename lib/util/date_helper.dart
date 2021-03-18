import 'package:intl/intl.dart';

class DateHelper {
  static String currentDateAsString() {
    DateTime dateTime = DateTime.now();
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  static String dateAsString(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  static int dayFromStringDate(String stringDate) {
    return DateTime.parse(stringDate).day;
  }
}
