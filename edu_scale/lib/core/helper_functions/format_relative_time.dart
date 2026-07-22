String formatRelativeTime(DateTime date) {
  final difference = DateTime.now().difference(date.toLocal());

  if (difference.inMinutes < 1) {
    return "Just now";
  }
  if (difference.inMinutes < 60) {
    return "${difference.inMinutes}Min";
  }
  if (difference.inHours < 24) {
    return "${difference.inHours}Hrs";
  }

  if (difference.inDays < 7) {
    final hours = difference.inHours % 24;
    return hours == 0
        ? "${difference.inDays}D"
        : "${difference.inDays}D ${hours}Hrs";
  }

  if (difference.inDays < 30) {
    final weeks = difference.inDays ~/ 7;
    return "${weeks}W";
  }

  if (difference.inDays < 365) {
    final months = difference.inDays ~/ 30;
    return "${months}Mo";
  }

  final years = difference.inDays ~/ 365;
  return "${years}Y";
}
