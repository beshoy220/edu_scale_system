import 'package:edu_scale/parent/calendar/presentation/pages/parent_calendar_page.dart';
import 'package:edu_scale/parent/community/presentation/pages/parent_community_page.dart';
import 'package:edu_scale/parent/home_base/presentation/pages/parent_home_page.dart';
import 'package:edu_scale/parent/settings/presentation/pages/parent_settings_page.dart';
import 'package:flutter/cupertino.dart';

List parentNav = [
  {'label': 'Home', 'icon': CupertinoIcons.home, 'page': ParentHomePage()},
  {
    'label': 'Community',
    'icon': CupertinoIcons.chat_bubble,
    'page': ParentCommunityPage(),
  },
  {
    'label': 'Calendar',
    'icon': CupertinoIcons.calendar,
    'page': ParentCalendarPage(),
  },
  {
    'label': 'Settings',
    'icon': CupertinoIcons.settings,
    'page': ParentSettingsPage(),
  },
];
