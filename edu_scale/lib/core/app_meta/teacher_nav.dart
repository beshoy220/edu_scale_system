import 'package:edu_scale/teacher/calendar/presentation/pages/teacher_calendar_page.dart';
import 'package:edu_scale/teacher/community/presentation/pages/teacher_community_page.dart';
import 'package:edu_scale/teacher/home_base/presentation/pages/teacher_home_page.dart';
import 'package:edu_scale/teacher/settings/presentation/pages/teacher_settings_page.dart';
import 'package:flutter/cupertino.dart';

List teacherNav = [
  {'label': 'Home', 'icon': CupertinoIcons.home, 'page': TeacherHomePage()},
  {
    'label': 'Community',
    'icon': CupertinoIcons.chat_bubble,
    'page': TeacherCommunityPage(),
  },
  {
    'label': 'Calendar',
    'icon': CupertinoIcons.calendar,
    'page': TeacherCalendarPage(),
  },
  {
    'label': 'Settings',
    'icon': CupertinoIcons.settings,
    'page': TeacherSettingsPage(),
  },
];
