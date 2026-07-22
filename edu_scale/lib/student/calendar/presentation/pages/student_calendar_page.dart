import 'package:edu_scale/core/helper_functions/get_day_of_the_week.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/calendar/presentation/providers/student_attendance_provider.dart';
import 'package:edu_scale/student/calendar/presentation/providers/student_events_provider.dart';
import 'package:edu_scale/student/calendar/presentation/providers/student_time_table_provider.dart';
import 'package:edu_scale/student/calendar/presentation/widgets/student_attendance_time_line.dart';
import 'package:edu_scale/student/calendar/presentation/widgets/student_calendar_days_selector.dart';
import 'package:edu_scale/student/calendar/presentation/widgets/student_event_time_line.dart';
import 'package:edu_scale/student/calendar/presentation/widgets/student_time_table_time_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// NOTE: this file is okay, but before adding any more logic please consider
// simplifing its architecture
class StudentCalendarPage extends StatefulWidget {
  const StudentCalendarPage({super.key});

  @override
  State<StudentCalendarPage> createState() => _StudentCalendarPageState();
}

class _StudentCalendarPageState extends State<StudentCalendarPage> {
  DateTime selectedDate = DateTime.now();

  final List<Map<String, String>> studentCalenderTimeLines = [
    {'label': 'Attendance'},
    {'label': 'Time Table'},
    {'label': 'Events'},
  ];

  int selectedTimeLineIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudentAttendanceProvider>().getAttendance(
        date: selectedDate,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    context.watch<StudentEventsProvider>().clearEvents();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = context.watch<StudentAttendanceProvider>();
    final timeTableProvider = context.watch<StudentTimeTableProvider>();
    final eventsProvider = context.watch<StudentEventsProvider>();

    void callProviderLogic(DateTime date) {
      if (selectedTimeLineIndex == 0) {
        context.read<StudentAttendanceProvider>().getAttendance(date: date);

        context.read<StudentEventsProvider>().clearEvents();
      } else if (selectedTimeLineIndex == 1) {
        context.read<StudentTimeTableProvider>().getTimeTableSessions(
          dayOfWeek: getDayOfWeek(date),
        );

        context.read<StudentEventsProvider>().clearEvents();
      } else {
        final provider = Provider.of<StudentEventsProvider>(
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
                    itemCount: studentCalenderTimeLines.length,
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
                        child: Text(studentCalenderTimeLines[index]['label']!),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              StudentCalendarDaysSelector(
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
                child: StudentAttendanceTimeLine(
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
                child: StudentTimeTableTimeLine(
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
                child: StudentEventsTimeLine(
                  events: eventsProvider.listOfEventsOfDaySelected,
                ),
              );
            },
          ),
      ],
    );
  }
}
