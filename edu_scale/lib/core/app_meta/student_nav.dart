import 'package:edu_scale/student/calendar/presentation/pages/student_calendar_page.dart';
import 'package:edu_scale/student/community/presentation/pages/student_community_page.dart';
import 'package:edu_scale/student/home_base/presentation/pages/student_home_page.dart';
import 'package:edu_scale/student/progress/presentation/pages/student_progress_page.dart';
import 'package:edu_scale/student/settings/presentation/pages/student_settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List studentNav = [
  {'label': 'Home', 'icon': CupertinoIcons.home, 'page': StudentHomePage()},
  {
    'label': 'Community',
    'icon': CupertinoIcons.chat_bubble,
    'page': StudentCommunityPage(),
  },
  {
    'label': 'Progress',
    'icon': Icons.rocket_launch_outlined,
    'page': StudentProgressPage(),
  },
  {
    'label': 'Calendar',
    'icon': CupertinoIcons.calendar,
    'page': StudentCalendarPage(),
  },
  {
    'label': 'Settings',
    'icon': CupertinoIcons.settings,
    'page': StudentSettingsPage(),
  },
];
