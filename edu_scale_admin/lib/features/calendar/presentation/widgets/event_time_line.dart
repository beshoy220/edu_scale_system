import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/event_model.dart';
import '../providers/events_provider.dart';

class EventsTimeLine extends StatelessWidget {
  final List<EventModel> events;

  const EventsTimeLine({super.key, required this.events});

  static const double hourHeight = 120;
  static const int startHour = 6;
  static const int endHour = 24;

  /// Every event should be at least this tall so the UI never overflows.
  static const double minEventHeight = 80;

  @override
  Widget build(BuildContext context) {
    final totalHours = endHour - startHour;
    final positionedEvents = generatePositionedEvents(events);

    return SizedBox(
      height: totalHours * hourHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HOURS COLUMN
          SizedBox(
            width: 75,
            child: Column(
              children: List.generate(totalHours, (index) {
                final hour = index + startHour;

                return SizedBox(
                  height: hourHeight,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      hour == 0 ? '12 PM' : formatHour(hour),
                      style: TextStyle(color: AppStyle.colors.black),
                    ),
                  ),
                );
              }),
            ),
          ),

          /// EVENTS
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: positionedEvents.map((item) {
                    return Positioned(
                      top: item.top,
                      left: item.left * constraints.maxWidth,
                      width: item.width * constraints.maxWidth,
                      child: EventCard(event: item.event, height: item.height),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //==============================================================
  // EVENT POSITIONING
  //==============================================================

  List<PositionedEvent> generatePositionedEvents(List<EventModel> events) {
    final result = <PositionedEvent>[];

    final sorted = [...events];

    sorted.sort(
      (a, b) => parseMinutes(a.startTime).compareTo(parseMinutes(b.startTime)),
    );

    for (final current in sorted) {
      final overlaps = sorted.where((other) {
        if (current.id == other.id) return true;
        return isOverlapping(current, other);
      }).toList();

      final overlapIndex = overlaps.indexOf(current);

      final width = 1 / overlaps.length;

      result.add(
        PositionedEvent(
          event: current,
          top: calculateTopPosition(current.startTime),
          height: calculateEventHeight(current.startTime, current.endTime),
          left: overlapIndex * width,
          width: width,
        ),
      );
    }

    return result;
  }

  //==============================================================
  // OVERLAP
  //==============================================================

  bool isOverlapping(EventModel a, EventModel b) {
    int aStart = parseMinutes(a.startTime);
    int aEnd = parseMinutes(a.endTime);

    int bStart = parseMinutes(b.startTime);
    int bEnd = parseMinutes(b.endTime);

    // Event passes midnight
    if (aEnd <= aStart) {
      aEnd += 24 * 60;
    }

    if (bEnd <= bStart) {
      bEnd += 24 * 60;
    }

    return aStart < bEnd && aEnd > bStart;
  }

  //==============================================================
  // TIME HELPERS
  //==============================================================

  int parseMinutes(String time) {
    final parts = time.split(':');

    return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
  }

  double calculateTopPosition(String time) {
    final parts = time.split(':');

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final totalMinutes = ((hour - startHour) * 60) + minute;

    return (totalMinutes / 60) * hourHeight;
  }

  double calculateEventHeight(String start, String end) {
    int startMinutes = parseMinutes(start);
    int endMinutes = parseMinutes(end);

    // Cross midnight
    if (endMinutes <= startMinutes) {
      endMinutes += 24 * 60;
    }

    final duration = endMinutes - startMinutes;

    final height = (duration / 60) * hourHeight;

    return height < minEventHeight ? minEventHeight : height;
  }

  String formatHour(int hour) {
    final suffix = hour >= 12 ? 'PM'.tr() : 'AM'.tr();

    final displayHour = hour > 12 ? hour - 12 : hour;

    return '$displayHour $suffix';
  }
}

class PositionedEvent {
  final EventModel event;
  final double top;
  final double height;
  final double left;
  final double width;

  PositionedEvent({
    required this.event,
    required this.top,
    required this.height,
    required this.left,
    required this.width,
  });
}

class EventCard extends StatefulWidget {
  final EventModel event;
  final double height;

  const EventCard({super.key, required this.event, required this.height});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isUserHovering = false;

  @override
  Widget build(BuildContext context) {
    final compact = widget.height < 100;
    final medium = widget.height < 140;

    return MouseRegion(
      onEnter: (_) => setState(() => isUserHovering = true),
      onExit: (_) => setState(() => isUserHovering = false),
      child: Container(
        height: widget.height.clamp(70.0, double.infinity),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppStyle.colors.grey,
          borderRadius: BorderRadius.circular(18),
        ),
        child: compact
            ? _buildCompactLayout(context)
            : _buildNormalLayout(context, showDescription: !medium),
      ),
    );
  }

  //==========================================================
  // COMPACT CARD
  //==========================================================

  Widget _buildCompactLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.event.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(width: 6),

        Text(
          getDurationText(widget.event.startTime, widget.event.endTime),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        if (isUserHovering)
          IconButton(
            splashRadius: 18,
            icon: Icon(
              CupertinoIcons.trash,
              color: AppStyle.colors.red,
              size: 20,
            ),
            onPressed: _deleteEvent,
          ),
      ],
    );
  }

  //==========================================================
  // NORMAL CARD
  //==========================================================

  Widget _buildNormalLayout(
    BuildContext context, {
    required bool showDescription,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.event.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(width: 8),

            Text(getDurationText(widget.event.startTime, widget.event.endTime)),

            if (isUserHovering)
              IconButton(
                splashRadius: 18,
                icon: Icon(
                  CupertinoIcons.trash,
                  color: AppStyle.colors.red,
                  size: 20,
                ),
                onPressed: _deleteEvent,
              )
            else
              const SizedBox(width: 40),
          ],
        ),

        if (showDescription) ...[
          const SizedBox(height: 8),

          Expanded(
            child: Text(
              widget.event.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black.withAlpha(180)),
            ),
          ),
        ],
      ],
    );
  }

  //==========================================================
  // DELETE
  //==========================================================

  void _deleteEvent() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppStyle.colors.surface,
          title: Text('Delete Event'.tr()),
          content: Text(
            'Are you sure you want to delete this event? This action cannot be undone.'
                .tr(),
            style: AppStyle.theme.primaryTextTheme.bodyMedium,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel'.tr(),
                style: TextStyle(color: AppStyle.colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                context.read<EventsProvider>().deleteEvent(
                  eventId: widget.event.id,
                );

                Navigator.pop(context);
              },
              child: Text('Delete'.tr()),
            ),
          ],
        );
      },
    );
  }

  //==========================================================
  // DURATION
  //==========================================================

  String getDurationText(String start, String end) {
    int parse(String t) {
      final p = t.split(':');
      return int.parse(p[0]) * 60 + int.parse(p[1]);
    }

    int startMinutes = parse(start);
    int endMinutes = parse(end);

    // Event continues into the next day.
    if (endMinutes <= startMinutes) {
      endMinutes += 24 * 60;
    }

    final duration = endMinutes - startMinutes;

    final hours = duration ~/ 60;
    final minutes = duration % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}m';
    }

    if (hours > 0) {
      return '${hours}h';
    }

    return '${minutes}m';
  }
}
