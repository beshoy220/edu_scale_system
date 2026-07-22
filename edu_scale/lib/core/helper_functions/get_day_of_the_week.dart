import 'package:intl/intl.dart';

/// This function convert the day [date] param from Sat, Sun...Fri to int as 1,2..7
int getDayOfWeek(DateTime date) {
  switch (DateFormat('EEE').format(date)) {
    case 'Sat':
      return 1;
    case 'Sun':
      return 2;
    case 'Mon':
      return 3;
    case 'Tue':
      return 4;
    case 'Wed':
      return 5;
    case 'Thu':
      return 6;
    case 'Fri':
      return 7;
    default:
      throw Exception('Invalid day');
  }
}
