import 'package:edu_scale/core/helper_functions/get_day_of_the_week.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/calendar/presentation/providers/parent_attendance_provider.dart';
import 'package:edu_scale/parent/calendar/presentation/providers/parent_events_provider.dart';
import 'package:edu_scale/parent/calendar/presentation/providers/parent_time_table_provider.dart';
import 'package:edu_scale/parent/calendar/presentation/widgets/parent_attendance_time_line.dart';
import 'package:edu_scale/parent/calendar/presentation/widgets/parent_calendar_days_selector.dart';
import 'package:edu_scale/parent/calendar/presentation/widgets/parent_event_time_line.dart';
import 'package:edu_scale/parent/calendar/presentation/widgets/parent_time_table_time_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// NOTE: this file is okay, but before adding any more logic please consider
// simplifing its architecture
class ParentCalendarPage extends StatefulWidget {
  const ParentCalendarPage({super.key});

  @override
  State<ParentCalendarPage> createState() => _ParentCalendarPageState();
}

class _ParentCalendarPageState extends State<ParentCalendarPage> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, String>> parentCalenderTimeLines = [
    {'label': 'Attendance'},
    {'label': 'Time Table'},
    {'label': 'Events'},
  ];

  int selectedTimeLineIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ParentAttendanceProvider>().getAttendance(
        date: selectedDate,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    context.watch<ParentEventsProvider>().clearEvents();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<ParentAttendanceProvider>();
    final timeTableProvider = context.watch<ParentTimeTableProvider>();
    final eventsProvider = context.watch<ParentEventsProvider>();

    void callProviderLogic(DateTime date) {
      if (selectedTimeLineIndex == 0) {
        context.read<ParentAttendanceProvider>().getAttendance(date: date);

        context.read<ParentEventsProvider>().clearEvents();
      } else if (selectedTimeLineIndex == 1) {
        context.read<ParentTimeTableProvider>().getTimeTableSessions(
          dayOfWeek: getDayOfWeek(date),
        );

        context.read<ParentEventsProvider>().clearEvents();
      } else {
        final provider = Provider.of<ParentEventsProvider>(
          context,
          listen: false,
        );

        if (provider.twoMonthEvents.isEmpty) {
          provider.getEventsByDate(date);
        } else {
          provider.setSelectedDay(date);
        }
      }
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          decoration: BoxDecoration(
            color: AppStyle.colors.green,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Calendar',
                    style: AppStyle.theme.primaryTextTheme.titleLarge?.copyWith(
                      color: AppStyle.colors.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                    style: TextStyle(color: AppStyle.colors.surface),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: parentCalenderTimeLines.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.colors.black,
                          foregroundColor: AppStyle.colors.surface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 4,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedTimeLineIndex = index;
                          });

                          callProviderLogic(selectedDate);
                        },
                        child: Text(parentCalenderTimeLines[index]['label']!),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ParentCalendarDaysSelector(
                eventDates: eventsProvider.listOfDaysThatHaveEvents,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });

                  callProviderLogic(selectedDate);
                },
                onPageChanged: (_) {
                  eventsProvider.getEventsByDate(selectedDate);
                },
              ),
            ],
          ),
        ),

        if (selectedTimeLineIndex == 0)
          Builder(
            builder: (_) {
              if (attendanceProvider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: LinearProgressIndicator(),
                );
              }

              if (attendanceProvider.errorMessage != null) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    attendanceProvider.errorMessage!,
                    style: TextStyle(color: AppStyle.colors.red),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ParentAttendanceTimeLine(
                  attendance: attendanceProvider.attendance,
                ),
              );
            },
          )
        else if (selectedTimeLineIndex == 1)
          Builder(
            builder: (_) {
              if (timeTableProvider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: LinearProgressIndicator(),
                );
              }

              if (timeTableProvider.errorMessage != null) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    timeTableProvider.errorMessage!,
                    style: TextStyle(color: AppStyle.colors.red),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: ParentTimeTableTimeLine(
                  sessions: timeTableProvider.sessions,
                ),
              );
            },
          )
        else if (selectedTimeLineIndex == 2)
          Builder(
            builder: (_) {
              if (eventsProvider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: LinearProgressIndicator(),
                );
              }

              if (eventsProvider.errorMessage != null) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    eventsProvider.errorMessage!,
                    style: TextStyle(color: AppStyle.colors.red),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(12),
                child: ParentEventsTimeLine(
                  events: eventsProvider.listOfEventsOfDaySelected,
                ),
              );
            },
          ),
      ],
    );
  }
}
