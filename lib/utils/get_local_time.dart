import 'package:intl/intl.dart';

String getLocalTime(DateTime utcTime) {
  // Convert the UTC time to your local time zone
  DateTime localTime = utcTime.toLocal();

  // Format the local time as a string (you can customize the format)
  return DateFormat().add_jm().format(localTime);
}

String formatUtcDate(DateTime utcDate) {
  // Get the current date in local time
  DateTime now = DateTime.now();

  // Calculate the difference in days between the current date and the UTC date
  int dayDifference = now.difference(utcDate).inDays;

  if (dayDifference == 0) {
    return 'Today';
  } else if (dayDifference == 1) {
    return 'Yesterday';
  } else if (dayDifference >= 2 && dayDifference <= 6) {
    // Get the day of the week for the UTC date
    String dayOfWeek = DateFormat('EEEE').format(utcDate);
    return dayOfWeek;
  } else {
    // Format the date as "Month Day, Year"
    return DateFormat('MMMM d, yyyy').format(utcDate);
  }
}
