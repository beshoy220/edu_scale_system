import 'package:edu_scale/core/helper_functions/get_day_of_the_week.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/teacher/calendar/presentation/providers/teacher_events_provider.dart';
import 'package:edu_scale/teacher/calendar/presentation/providers/teacher_time_table_provider.dart';
import 'package:edu_scale/teacher/calendar/presentation/widgets/teacher_calendar_days_selector.dart';
import 'package:edu_scale/teacher/calendar/presentation/widgets/teacher_time_table_time_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherCalendarPage extends StatefulWidget {
  const TeacherCalendarPage({super.key});

  @override
  State<TeacherCalendarPage> createState() => _TeacherCalendarPageState();
}

class _TeacherCalendarPageState extends State<TeacherCalendarPage> {
  DateTime selectedDate = DateTime.now();
  bool showTimeTable = true;

  @override
  void initState() {
    super.initState();

    // NOTE: In this widget we load time table sessions in initState but events from events button
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeacherTimeTableProvider>().loadTimeTableSessions(
        dayOfWeek: getDayOfWeek(DateTime.now()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<TeacherEventsProvider>();
    final timeTableProvider = context.watch<TeacherTimeTableProvider>();

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
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.colors.black, // Button color
                        foregroundColor: AppStyle.colors.surface, // Text color
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showTimeTable = true;
                        });
                      },
                      child: const Text('Time Table'),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.colors.black, // Button color
                        foregroundColor: AppStyle.colors.surface, // Text color
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          showTimeTable = false;
                          context.read<TeacherTimeTableProvider>();
                        });
                      },
                      child: const Text('Events'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              TeacherCalendarDaysSelector(
                eventDates: showTimeTable
                    ? []
                    : eventProvider.listOfDaysThatHaveEvents,

                onDateSelected: (date) {
                  if (showTimeTable) {
                    timeTableProvider.loadTimeTableSessions(
                      dayOfWeek: getDayOfWeek(date),
                    );
                  }

                  context.read<TeacherEventsProvider>().getEventsByDate(date);

                  setState(() {
                    selectedDate = date;
                  });
                },

                onPageChanged: (date) {
                  context.read<TeacherEventsProvider>().getEventsByDate(date);
                },
              ),
            ],
          ),
        ),

        (showTimeTable)
            ? Builder(
                builder: (_) {
                  if (timeTableProvider.isLoading) {
                    return const Center(child: LinearProgressIndicator());
                  }

                  if (timeTableProvider.errorMessage != null) {
                    return Center(child: Text(timeTableProvider.errorMessage!));
                  }

                  if (timeTableProvider.timeTableSessions.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'No timetable sessions for selected day\nMaybe today is a holiday!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return TeacherTimeTableTimeLine(
                    sessions: timeTableProvider.timeTableSessions,
                  );
                },
              )
            : Builder(
                builder: (_) {
                  if (eventProvider.isLoading) {
                    return const Center(child: LinearProgressIndicator());
                  }

                  if (eventProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        eventProvider.errorMessage!,
                        style: TextStyle(color: AppStyle.colors.red),
                      ),
                    );
                  }

                  if (eventProvider.listOfEventsOfDaySelected.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(height: 24),
                        Center(
                          child: Text(
                            'No events for ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: eventProvider.listOfEventsOfDaySelected.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final event =
                          eventProvider.listOfEventsOfDaySelected[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),

                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppStyle.colors.grey,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(event.description),
                                Text('${event.startTime} - ${event.endTime}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ],
    );
  }
}
