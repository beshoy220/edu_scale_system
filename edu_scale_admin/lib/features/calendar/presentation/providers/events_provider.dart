import 'package:flutter/material.dart';
import '../../data/data_sources/add_event_remote_data_source.dart';
import '../../data/data_sources/delete_event_remote_data_source.dart';
import '../../data/data_sources/get_events_remote_data_source.dart';
import '../../data/models/event_model.dart';

class EventsProvider extends ChangeNotifier {
  List<EventModel> twoMonthEvents = [];

  /// All unique days that contain at least one event
  List<DateTime> listOfDaysThatHaveEvents = [];

  /// Events of the currently selected day
  List<EventModel> listOfEventsOfDaySelected = [];

  bool isLoading = false;
  String? errorMessage;

  // Fetches events for a given date and updates the state accordingly
  Future<void> getEventsByDate(DateTime date) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await GetEventsRemoteDataSource().getByDateRange(date);

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

  Future<void> addEvent({
    required String title,
    required String description,
    required DateTime dayDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
  }) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      await AddEventRemoteDataSource().addEvent(
        title: title,
        description: description,
        dayDate: dayDate,
        startTime: startTime,
        endTime: endTime,
      );

      await getEventsByDate(dayDate);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  void clearEvents() {
    twoMonthEvents = [];
    listOfDaysThatHaveEvents = [];
    listOfEventsOfDaySelected = [];
    notifyListeners();
  }

  Future<void> deleteEvent({required int eventId}) async {
    try {
      await DeleteEventRemoteDataSource().deleteEvent(eventId);

      // Remove the deleted event from the local list of events
      twoMonthEvents.removeWhere((e) => e.id == eventId);
      _buildDaysWithEvents();
      listOfEventsOfDaySelected.removeWhere((e) => e.id == eventId);

      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
