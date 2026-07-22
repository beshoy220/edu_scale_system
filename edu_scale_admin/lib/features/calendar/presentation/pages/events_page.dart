import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/calendar/presentation/widgets/add_event_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/events_provider.dart';
import '../../../../core/shared_components/builders/responsive_layout_builder.dart';
import '../widgets/calendar_days_selector.dart';
import '../widgets/event_time_line.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  DateTime selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<EventsProvider>().getEventsByDate(selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventsProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Events'.tr(),
                    style: AppStyle.theme.primaryTextTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'My school events'.tr(),
                    style: AppStyle.theme.primaryTextTheme.bodySmall,
                  ),
                ],
              ),

              ResponsiveLayoutBuilder(
                small: IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
                medium: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.colors.green,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AddEventDialog(
                          onCreate:
                              ({
                                required dayDate,
                                required description,
                                required endTime,
                                required startTime,
                                required title,
                              }) async {
                                await provider.addEvent(
                                  title: title,
                                  description: description,
                                  dayDate: dayDate,
                                  startTime: startTime,
                                  endTime: endTime,
                                );
                              },
                        );
                      },
                    );
                  },
                  child: Text('+ Add Event'.tr()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Calendar
          CalendarDaysSelector(
            initialDate: selectedDay,
            eventDates: provider.listOfDaysThatHaveEvents,
            onDateSelected: (selected) {
              setState(() {
                selectedDay = selected;
              });

              provider.setSelectedDay(selected);
            },
            onPageChanged: (focused) {
              setState(() {
                selectedDay = focused;
              });

              provider.clearError();
              provider.clearEvents();
              provider.getEventsByDate(focused);
            },
          ),

          const SizedBox(height: 20),

          Divider(color: AppStyle.colors.grey),

          // Loading
          if (provider.isLoading) ...[
            const SizedBox(height: 20),
            const LinearProgressIndicator(),
          ],

          // Error
          if (provider.errorMessage != null) ...[
            const SizedBox(height: 20),
            Text(
              provider.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ],

          // Empty State
          if (!provider.isLoading &&
              provider.errorMessage == null &&
              provider.listOfEventsOfDaySelected.isEmpty) ...[
            const SizedBox(height: 30),

            Text(
              '${'No events found for'.tr()} ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
              style: AppStyle.theme.primaryTextTheme.bodySmall,
            ),
          ],

          // Events Timeline
          if (!provider.isLoading &&
              provider.listOfEventsOfDaySelected.isNotEmpty) ...[
            const SizedBox(height: 10),

            EventsTimeLine(events: provider.listOfEventsOfDaySelected),
          ],
        ],
      ),
    );
  }
}
