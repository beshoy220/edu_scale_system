import 'package:easy_localization/easy_localization.dart';
import 'package:edu_scale_admin/core/app_meta/app_meta.dart';
import 'package:edu_scale_admin/core/shared_pref/cached_resources.dart';
import 'package:edu_scale_admin/core/supabase_service/supabase_client.dart';
import 'package:edu_scale_admin/core/themes/themes.dart';
import 'package:edu_scale_admin/features/calendar/presentation/providers/events_provider.dart';
import 'package:edu_scale_admin/features/calendar/presentation/providers/time_table_provider.dart';
import 'package:edu_scale_admin/features/classes/presentation/providers/class_statistics_provider.dart';
import 'package:edu_scale_admin/features/classes/presentation/providers/classes_list_provider.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/pages/dashboard_base_page.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/providers/auth_data_provider.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/providers/dashboard_index_provider.dart';
import 'package:edu_scale_admin/features/dashboard_base/presentation/providers/school_statistics_provider.dart';
import 'package:edu_scale_admin/features/school_activities/presentation/providers/library_resources_provider.dart';
import 'package:edu_scale_admin/features/school_users/parents/presentation/providers/create_parents_students_provider.dart';
import 'package:edu_scale_admin/features/school_users/parents/presentation/providers/parents_provider.dart';
import 'package:edu_scale_admin/features/school_users/students/presentation/providers/students_provider.dart';
import 'package:edu_scale_admin/features/school_users/teachers/presentation/providers/subjects_provider.dart';
import 'package:edu_scale_admin/features/school_users/teachers/presentation/providers/teachers_list_provider.dart';
import 'package:edu_scale_admin/features/more/presentation/providers/settings_provider.dart';
import 'package:edu_scale_admin/features/template/presentation/providers/template_provider.dart';
import 'package:edu_scale_admin/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/presentation/pages/on_boarding_page.dart';
import 'features/auth/presentation/providers/school_setup_provider.dart';
import 'features/auth/presentation/providers/sign_in_provider.dart';
import 'features/calendar/presentation/providers/teacher_list_for_time_table.dart';
import 'features/community/presentation/providers/channel_message_provider.dart';
import 'features/community/presentation/providers/channels_provider.dart';
import 'features/gamefication/presentation/providers/competition_statistics_provider.dart';
import 'features/more/presentation/providers/reply_support_ticket_provider.dart';
import 'features/more/presentation/providers/ticket_provider.dart';
import 'features/school_activities/presentation/providers/assignment_statistics_provider.dart';
import 'features/school_activities/presentation/providers/attendance_statistics_provider.dart';
import 'features/school_activities/presentation/providers/quiz_statistics_provider.dart';
import 'features/school_users/admins/presentation/providers/admins_list_provider.dart';
import 'features/school_users/parents/presentation/providers/classe_for_parents_provider.dart';
import 'features/school_users/students/presentation/providers/classe_for_students_provider.dart';
import 'features/school_users/students/presentation/providers/create_studnets_parents_provider.dart';
import 'features/school_users/teachers/presentation/providers/create_teachers_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await AppDependencies.initDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/translations/',
      fallbackLocale: await CachedResources.isAppLanguageEnglish()
          ? const Locale('en', 'US')
          : const Locale('ar', 'EG'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemplateProvider(sl())..fetch()),

        ChangeNotifierProvider(create: (_) => SignInProvider()),
        ChangeNotifierProvider(create: (_) => SchoolSetupProvider()),

        ChangeNotifierProvider(create: (_) => DashBoardIndexProvider()),

        ChangeNotifierProvider(create: (_) => AuthDataProvider()),
        ChangeNotifierProvider(create: (_) => SchoolStatisticsProvider()),

        ChangeNotifierProvider(create: (_) => ChannelsProvider()),
        ChangeNotifierProvider(create: (_) => ChannelMessagesProvider()),

        ChangeNotifierProvider(create: (_) => StudentsProvider()),
        ChangeNotifierProvider(create: (_) => ClassesForStudentsProvider()),
        ChangeNotifierProvider(create: (_) => CreateStudnetsParentsProvider()),

        ChangeNotifierProvider(create: (_) => ParentsProvider()),
        ChangeNotifierProvider(create: (_) => ClassesForParentsProvider()),
        ChangeNotifierProvider(create: (_) => CreateParentsStudnetsProvider()),

        ChangeNotifierProvider(create: (_) => TeachersListProvider()),
        ChangeNotifierProvider(create: (_) => SubjectProvider()),

        ChangeNotifierProvider(create: (_) => AdminsListProvider()),

        ChangeNotifierProvider(create: (_) => CreateTeachersProvider()),

        ChangeNotifierProvider(create: (_) => ClassStatisticsProvider()),
        ChangeNotifierProvider(create: (_) => ClassesListProvider()),

        ChangeNotifierProvider(create: (_) => EventsProvider()),
        ChangeNotifierProvider(create: (_) => TeacherListForTimeTable()),
        ChangeNotifierProvider(create: (_) => TimeTableProvider()),

        ChangeNotifierProvider(create: (_) => AssignmentStatisticsProvider()),
        ChangeNotifierProvider(create: (_) => QuizStatisticsProvider()),
        ChangeNotifierProvider(create: (_) => LibraryResourcesProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceStatisticsProvider()),

        ChangeNotifierProvider(create: (_) => CompetitionStatisticsProvider()),

        ChangeNotifierProvider(create: (_) => SupportTicketsProvider()),
        ChangeNotifierProvider(create: (_) => ReplySupportTicketProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppMeta.appName,
        theme: AppStyle.theme,

        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,

        home: StreamBuilder(
          stream: SupabaseConfig.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            // check if there is a current session
            final session = SupabaseConfig.client.auth.currentSession;

            if (session != null) {
              // User is signed in
              return DashboardBasePage();
            } else {
              // User is not signed in
              return OnBoardingPage();
            }
          },
        ),
      ),
    );
  }
}
