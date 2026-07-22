import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/themes/themes.dart';

class CalendarDaysSelector extends StatefulWidget {
  final Function(DateTime selectedDate) onDateSelected;
  final Function(DateTime focusedDay) onPageChanged;
  final DateTime? initialDate;
  final List<DateTime> eventDates;

  const CalendarDaysSelector({
    super.key,
    required this.onDateSelected,
    required this.onPageChanged,
    required this.eventDates,
    this.initialDate,
  });

  @override
  State<CalendarDaysSelector> createState() => _CalendarDaysSelectorState();
}

class _CalendarDaysSelectorState extends State<CalendarDaysSelector> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;

  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();

    _selectedDay = widget.initialDate ?? DateTime.now();
    _focusedDay = _selectedDay;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected(_selectedDay);
    });
  }

  bool _hasEvent(DateTime day) {
    return widget.eventDates.any(
      (event) =>
          event.year == day.year &&
          event.month == day.month &&
          event.day == day.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(
                '${_focusedDay.month}/${_focusedDay.year}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              IconButton(
                icon: Icon(
                  _calendarFormat == CalendarFormat.week
                      ? CupertinoIcons.calendar
                      : Icons.view_week,
                ),
                onPressed: () {
                  setState(() {
                    _calendarFormat = _calendarFormat == CalendarFormat.week
                        ? CalendarFormat.month
                        : CalendarFormat.week;
                  });
                },
              ),
            ],
          ),
        ),

        TableCalendar(
          loadEventsForDisabledDays: true,
          firstDay: DateTime(2020),
          lastDay: DateTime(2040),

          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),

          calendarFormat: _calendarFormat,

          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },

          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            widget.onDateSelected(selectedDay);
          },

          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
            widget.onPageChanged(focusedDay);
          },

          eventLoader: (day) {
            return _hasEvent(day) ? ['event'] : [];
          },

          calendarStyle: CalendarStyle(
            tablePadding: EdgeInsets.all(8),
            cellPadding: EdgeInsets.all(8),
            cellMargin: EdgeInsets.all(4),

            markerSize: 8,
            markerDecoration: BoxDecoration(
              color: AppStyle.colors.yellow,
              shape: BoxShape.circle,
            ),

            selectedDecoration: BoxDecoration(
              color: AppStyle.colors.green,
              shape: BoxShape.circle,
              // borderRadius: BorderRadius.circular(8),
            ),

            todayDecoration: BoxDecoration(
              color: AppStyle.colors.green.withAlpha(150),
              shape: BoxShape.circle,
            ),

            markersMaxCount: 1,
          ),

          headerVisible: false,
        ),
      ],
    );
  }
}
