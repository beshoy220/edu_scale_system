import 'package:edu_scale_admin/features/calendar/presentation/pages/events_page.dart';
import 'package:edu_scale_admin/features/calendar/presentation/pages/time_table_page.dart';
import 'package:edu_scale_admin/features/classes/presentation/pages/my_classes_page.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/pages/home_page.dart';
import 'package:edu_scale_admin/features/school_activities/presentation/pages/assignments_page.dart';
import 'package:edu_scale_admin/features/school_activities/presentation/pages/attendance_page.dart';
import 'package:edu_scale_admin/features/school_activities/presentation/pages/library_page.dart';
import 'package:edu_scale_admin/features/school_activities/presentation/pages/quizzes_page.dart';
import 'package:edu_scale_admin/features/school_users/parents/presentation/pages/parents_page.dart';
import 'package:edu_scale_admin/features/school_users/students/presentation/pages/students_page.dart';
import 'package:edu_scale_admin/features/school_users/teachers/presentation/pages/teachers_page.dart';
import 'package:edu_scale_admin/features/school_users/admins/presentation/pages/admin_page.dart';
import 'package:edu_scale_admin/features/more/presentation/pages/settings_page.dart';
import 'package:flutter/widgets.dart';

import '../../features/more/presentation/pages/support_page.dart';

List<Widget> dashboardDisplayContent = [
  // Home screen
  HomePage(),

  // School users screens
  StudentsPage(),
  ParentsPage(),
  TeachersPage(),
  AdminsPage(),

  // My classes screens
  MyClassesPage(),

  // Calendar screens
  TimeTablePage(),
  EventsPage(),

  // School activities screens
  AttendancePage(),
  AssignmentsPage(),
  QuizzesPage(),
  LibraryPage(),

  // Gamefication screens
  // CompetitionsPage(),

  // More screens
  SupportPage(),
  SettingsPage(),
];
