import 'package:flutter/cupertino.dart';

List dashboardItems = [
  {
    'group': 'Home',
    'items': [
      {'icon': CupertinoIcons.house, 'title': 'Home'},
    ],
  },

  {
    'group': 'School Users',
    'items': [
      {'icon': CupertinoIcons.person, 'title': 'Students'},
      {'icon': CupertinoIcons.person_2, 'title': 'Parents'},
      {'icon': CupertinoIcons.briefcase, 'title': 'Teachers'},
      {'icon': CupertinoIcons.shield, 'title': 'Admins'},
    ],
  },

  {
    'group': 'Classes',
    'items': [
      {'icon': CupertinoIcons.square_grid_2x2, 'title': 'My Classes'},
    ],
  },

  {
    'group': 'Calendar',
    'items': [
      {'icon': CupertinoIcons.calendar, 'title': 'Timetable'},
      {'icon': CupertinoIcons.calendar_badge_plus, 'title': 'Events'},
    ],
  },

  {
    'group': 'School Activities',
    'items': [
      {'icon': CupertinoIcons.checkmark_seal, 'title': 'Attendance'},
      {'icon': CupertinoIcons.doc_text, 'title': 'Assignments'},
      {'icon': CupertinoIcons.doc, 'title': 'Quizzes'},
      {'icon': CupertinoIcons.book, 'title': 'Library'},
    ],
  },

  // {
  //   'group': 'Gamification',
  //   'items': [
  //     {'icon': CupertinoIcons.rocket, 'title': 'Competitions'},
  //   ],
  // },
  {
    'group': 'More',
    'items': [
      {'icon': CupertinoIcons.question_circle, 'title': 'Help & Support'},
      {'icon': CupertinoIcons.gear, 'title': 'Settings'},
    ],
  },
];

/// helper flattened list (IMPORTANT for index handling)
final flatDashboardItems = dashboardItems
    .expand((group) => group['items'] as List)
    .toList();
