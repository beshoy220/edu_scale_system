String timeFormatter(String timestamp) {
  final date = DateTime.parse(timestamp).toLocal();

  final hour = date.hour == 0
      ? 12
      : date.hour > 12
      ? date.hour - 12
      : date.hour;

  final period = date.hour >= 12 ? 'pm' : 'am';

  return '${date.year}:${date.month.toString().padLeft(2, '0')}:${date.day.toString().padLeft(2, '0')} '
      '$hour:${(date.minute < 9) ? '0${date.minute}' : date.minute} $period';
}
