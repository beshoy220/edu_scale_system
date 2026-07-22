import 'package:edu_scale/parent/calendar/data/data_sources/get_parent_events_remote_data_source.dart';
import 'package:edu_scale/parent/calendar/data/models/parent_event_model.dart';
import 'package:flutter/material.dart';

class ParentEventsProvider extends ChangeNotifier {
  List<ParentEventModel> twoMonthEvents = [];

  /// All unique days that contain at least one event
  List<DateTime> listOfDaysThatHaveEvents = [];

  /// Events of the currently selected day
  List<ParentEventModel> listOfEventsOfDaySelected = [];

  bool isLoading = false;
  String? errorMessage;

  // Fetches events for a given date and updates the state accordingly
  Future<void> getEventsByDate(DateTime date) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await GetParentEventsRemoteDataSource().getByDateRange(
        date,
      );

      twoMonthEvents = result;

      _buildDaysWithEvents();

      setSelectedDay(date);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a unique list of dates that have events
  void _buildDaysWithEvents() {
    final uniqueDays = <String, DateTime>{};

    for (final event in twoMonthEvents) {
      final day = DateTime(
        event.dayDate.year,
        event.dayDate.month,
        event.dayDate.day,
      );

      uniqueDays[day.toIso8601String()] = day;
    }

    listOfDaysThatHaveEvents = uniqueDays.values.toList()
      ..sort((a, b) => a.compareTo(b));
  }

  /// Updates events for a selected day
  void setSelectedDay(DateTime selectedDate) {
    listOfEventsOfDaySelected = twoMonthEvents.where((event) {
      return event.dayDate.year == selectedDate.year &&
          event.dayDate.month == selectedDate.month &&
          event.dayDate.day == selectedDate.day;
    }).toList();

    notifyListeners();
  }

  void clearEvents() {
    twoMonthEvents = [];
    listOfDaysThatHaveEvents = [];
    listOfEventsOfDaySelected = [];
    notifyListeners();
  }
}
