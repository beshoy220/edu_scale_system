import 'package:edu_scale/core/helper_functions/format_relative_time.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/student/home_base/presentation/providers/student_notification_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentBottomSheetNotifications extends StatefulWidget {
  const StudentBottomSheetNotifications({super.key});

  @override
  State<StudentBottomSheetNotifications> createState() =>
      _StudentBottomSheetNotificationsState();
}

class _StudentBottomSheetNotificationsState
    extends State<StudentBottomSheetNotifications> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;
      context.read<StudentNotificationProvider>().getLast50Notifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentNotificationProvider>();
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),

          if (provider.isLoading) Center(child: LinearProgressIndicator()),

          if (provider.errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(provider.errorMessage!, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),

          if (provider.notifications.isEmpty && !provider.isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Icon(Icons.notifications_none, size: 48, color: Colors.grey),
                  SizedBox(height: 12),
                  Text("No notifications yet", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.notifications.length,
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];

                return Padding(
                  padding: EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppStyle.colors.grey,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.bell),
                              Text(
                                formatRelativeTime(notification.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notification.body),
                                  const SizedBox(height: 6),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
