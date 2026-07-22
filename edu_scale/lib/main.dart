import 'package:edu_scale/app_dependencies.dart';
import 'package:edu_scale/core/push_notification_service/local_notifications_service.dart';
import 'package:edu_scale/core/push_notification_service/push_notifications_service.dart';
import 'package:edu_scale/firebase_options.dart';
import 'package:edu_scale/global_auth_manager/presentation/pages/language_selection_page.dart';
import 'package:edu_scale/global_auth_manager/presentation/providers/sign_in_provider.dart';
import 'package:edu_scale/core/app_meta/app_meta.dart';
import 'package:edu_scale/core/supabase_service/supabase_auth_service.dart';
import 'package:edu_scale/core/themes/themes.dart';
import 'package:edu_scale/parent/assignments/presentation/providers/parent_past_assignments_provider.dart';
import 'package:edu_scale/parent/calendar/presentation/providers/parent_attendance_provider.dart';
import 'package:edu_scale/parent/calendar/presentation/providers/parent_events_provider.dart';
import 'package:edu_scale/parent/calendar/presentation/providers/parent_time_table_provider.dart';
import 'package:edu_scale/parent/community/presentation/providers/parent_channel_messages_provider.dart';
import 'package:edu_scale/parent/community/presentation/providers/parent_channel_provider.dart';
import 'package:edu_scale/parent/home_base/presentation/pages/parent_home_base.dart';
import 'package:edu_scale/parent/home_base/presentation/providers/parent_nav_index_provider.dart';
import 'package:edu_scale/parent/home_base/presentation/providers/parent_notification_provider.dart';
import 'package:edu_scale/parent/home_base/presentation/providers/parent_student_info_provider.dart';
import 'package:edu_scale/parent/progress/presentation/providers/parent_available_badges_provider.dart';
import 'package:edu_scale/parent/progress/presentation/providers/parent_progress_provider.dart';
import 'package:edu_scale/parent/quizzes/presentation/providers/parent_past_quizzes_provider.dart';
import 'package:edu_scale/student/assignments/presentation/providers/student_assignment_provider.dart';
import 'package:edu_scale/student/assignments/presentation/providers/student_assignment_questions_provider.dart';
import 'package:edu_scale/student/calendar/presentation/providers/student_attendance_provider.dart';
import 'package:edu_scale/student/calendar/presentation/providers/student_events_provider.dart';
import 'package:edu_scale/student/calendar/presentation/providers/student_time_table_provider.dart';
import 'package:edu_scale/student/community/presentation/providers/student_channel_messages_provider.dart';
import 'package:edu_scale/student/community/presentation/providers/student_channel_provider.dart';
import 'package:edu_scale/student/home_base/presentation/pages/student_home_base.dart';
import 'package:edu_scale/student/home_base/presentation/providers/student_nav_index_provider.dart';
import 'package:edu_scale/student/home_base/presentation/providers/student_notification_provider.dart';
import 'package:edu_scale/student/library/presentation/providers/student_library_subjects_provider.dart';
import 'package:edu_scale/student/library/presentation/providers/student_library_resources_provider.dart';
import 'package:edu_scale/student/progress/presentation/providers/student_available_badges_provider.dart';
import 'package:edu_scale/student/progress/presentation/providers/student_progress_provider.dart';
import 'package:edu_scale/student/quizzes/presentation/providers/student_quiz_provider.dart';
import 'package:edu_scale/student/quizzes/presentation/providers/student_quiz_questions_provider.dart';
import 'package:edu_scale/teacher/assignments/presentation/providers/teacher_assignment_grade_classes_provider.dart';
import 'package:edu_scale/teacher/assignments/presentation/providers/teacher_assignment_provider.dart';
import 'package:edu_scale/teacher/assignments/presentation/providers/teacher_assignment_model_answer_provider.dart';
import 'package:edu_scale/teacher/assignments/presentation/providers/teacher_assignment_student_submissions_provider.dart';
import 'package:edu_scale/teacher/attendance/presentation/providers/teacher_attendance_provider.dart';
import 'package:edu_scale/teacher/calendar/presentation/providers/teacher_events_provider.dart';
import 'package:edu_scale/teacher/calendar/presentation/providers/teacher_time_table_provider.dart';
import 'package:edu_scale/teacher/community/presentation/providers/teacher_channel_message_provider.dart';
import 'package:edu_scale/teacher/community/presentation/providers/teacher_channels_provider.dart';
import 'package:edu_scale/teacher/home_base/presentation/pages/teacher_home_base.dart';
import 'package:edu_scale/teacher/home_base/presentation/providers/teacher_nav_index_provider.dart';
import 'package:edu_scale/teacher/home_base/presentation/providers/teacher_notification_provider.dart';
import 'package:edu_scale/teacher/library/presentation/providers/teacher_library_provider.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_grade_classes_provider.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_model_answer_provider.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_provider.dart';
import 'package:edu_scale/teacher/quizzes/presentation/providers/teacher_quiz_student_submissions_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await AppDependencies.initDependencies();

  await Future.wait([
    PushNotificationsService.init(),
    LocalNotificationService.init(),
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignInProvider()),

        ChangeNotifierProvider(create: (_) => StudentNavIndexProvider()),
        ChangeNotifierProvider(create: (_) => ParentNavIndexProvider()),
        ChangeNotifierProvider(create: (_) => TeacherNavIndexProvider()),

        ChangeNotifierProvider(create: (_) => TeacherNotificationProvider()),
        ChangeNotifierProvider(create: (_) => TeacherChannelsProvider()),
        ChangeNotifierProvider(create: (_) => TeacherChannelMessagesProvider()),
        ChangeNotifierProvider(create: (_) => TeacherEventsProvider()),
        ChangeNotifierProvider(create: (_) => TeacherTimeTableProvider()),
        ChangeNotifierProvider(create: (_) => TeacherAssignmentsProvider()),
        ChangeNotifierProvider(
          create: (_) => TeacherAssignmentStudentSubmissionsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TeacherAssignmentModelAnswerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TeacherAssignmentGradeClassesProvider(),
        ),
        ChangeNotifierProvider(create: (_) => TeacherQuizzesProvider()),
        ChangeNotifierProvider(
          create: (_) => TeacherQuizStudentSubmissionsProvider(),
        ),
        ChangeNotifierProvider(create: (_) => TeacherQuizModelAnswerProvider()),
        ChangeNotifierProvider(
          create: (_) => TeacherQuizGradeClassesProvider(),
        ),
        ChangeNotifierProvider(create: (_) => TeacherAttendanceProvider()),
        ChangeNotifierProvider(create: (_) => TeacherLibraryProvider()),

        ChangeNotifierProvider(create: (_) => ParentNotificationProvider()),
        ChangeNotifierProvider(create: (_) => ParentStudentInfoProvider()),
        ChangeNotifierProvider(create: (_) => ParentChannelsProvider()),
        ChangeNotifierProvider(create: (_) => ParentChannelMessagesProvider()),
        ChangeNotifierProvider(create: (_) => ParentAttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ParentTimeTableProvider()),
        ChangeNotifierProvider(create: (_) => ParentEventsProvider()),
        ChangeNotifierProvider(create: (_) => ParentPastAssignmentsProvider()),
        ChangeNotifierProvider(create: (_) => ParentPastQuizzesProvider()),
        ChangeNotifierProvider(create: (_) => ParentProgressProvider()),
        ChangeNotifierProvider(create: (_) => ParentAvailableBadgesProvider()),

        ChangeNotifierProvider(create: (_) => StudentNotificationProvider()),
        ChangeNotifierProvider(create: (_) => StudentChannelMessagesProvider()),
        ChangeNotifierProvider(create: (_) => StudentChannelsProvider()),
        ChangeNotifierProvider(create: (_) => StudentAttendanceProvider()),
        ChangeNotifierProvider(create: (_) => StudentTimeTableProvider()),
        ChangeNotifierProvider(create: (_) => StudentEventsProvider()),
        ChangeNotifierProvider(create: (_) => StudentAssignmentsProvider()),
        ChangeNotifierProvider(
          create: (_) => StudentAssignmentQuestionsProvider(),
        ),
        ChangeNotifierProvider(create: (_) => StudentQuizzesProvider()),
        ChangeNotifierProvider(create: (_) => StudentQuizQuestionsProvider()),
        ChangeNotifierProvider(create: (_) => StudentLibrarySubjectsProvider()),
        ChangeNotifierProvider(
          create: (_) => StudentLibraryResourcesProvider(),
        ),
        ChangeNotifierProvider(create: (_) => StudentProgressProvider()),
        ChangeNotifierProvider(create: (_) => StudentAvailableBadgesProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppMeta.appName,
        theme: AppStyle.theme,
        home: StreamBuilder(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            // check if there is a current session
            final session = Supabase.instance.client.auth.currentSession;

            if (session != null) {
              // User is signed in
              String currentUserRole =
                  SupabaseAuthService().currentUser?.appMetadata['role'];

              if (currentUserRole == 'student') {
                return StudentHomeBase();
              } else if (currentUserRole == 'parent') {
                return ParentHomeBase();
              } else if (currentUserRole == 'teacher') {
                return TeacherHomeBase();
              } else {
                return SafeArea(child: Scaffold(body: Text('No role cached')));
              }
            } else {
              // User is not signed in
              return LanguageSelectionPage();
            }
          },
        ),
      ),
    );
  }
}
