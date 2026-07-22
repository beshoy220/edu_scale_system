import 'dart:developer';

import 'package:edu_scale/core/account_manager/cached_account_model.dart';
import 'package:edu_scale/core/push_notification_service/local_notifications_service.dart';
import 'package:edu_scale/core/supabase_service/supabase_auth_service.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';
import 'package:edu_scale/core/supabase_service/supabase_edge_functions_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/*
  1.Permissions [done]
  2.fcm token [done]
  3.test using token with Firebase [done]
  4.fire notification [background] [done]
  5.fire notification [killed] [done]
  6.fire notification [foreground] [done]
  7.test using token with Postman [done]
  8.send Image with notification [done]
  9.send notfification with custom sound [done]
  10.send token to server [done]
  11.topic [done]
 */

/// -------------------------------------------
/// PushNotificationsService
/// -------------------------------------------
///
/// A PushNotificationsService class is just a wrapped for [FCM]
/// and [flutter_local_notifications] package
///
/// -------------------------------------------
/// Configuration
/// -------------------------------------------
/// 1. Create a Firebase project.
///
/// 2. Register your Flutter app in Firebase via flutterfire CLI
///    - run "flutterfire configure" in your terminal
///        - choose the project you just created
///        - choose the target platform
///        - you should end with a message like: lib\firebase_options.dart generated successfully
///
/// 3. Use the folllowing code to initioalize:
///
///    ```
///    WidgetsFlutterBinding.ensureInitialized();
///    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
///    await Future.wait([
///       PushNotificationsService.init(),
///       LocalNotificationService.init(),
///    ]);
///    ```
///
/// 4. Also check that Firebase Messaging is enabled from Firebase console.
///
/// 5. DO NOT FORGET to add [project_id] & [private_key] & [client_email] to
///    supabase edge env and add the "send-fcm" function. you can find them in
///    firebase admin sdk json file that has all keys.
///
/// Notes: You may have problems running in the android like changing some android values in android files.
/// Also keep in mind that iOS will require more config throught APNs Certificate
///
/// This is an arabic playlist that covers most of FCM topics and how to set up step by step:
/// https://www.youtube.com/watch?v=HY18CljLjkM&list=PLYfTCw9blWRMwKMz9e3MyewOTQQBbUt7e
///

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static TopicSubscriptionManager topics = TopicSubscriptionManager();
  static SendNotification sendNotification = SendNotification();

  static Future init() async {
    await messaging.requestPermission();

    // We get the token and save it to DB
    await messaging.getToken().then((token) {
      if (token != null) {
        _sendTokenToSupabase(token);
      } else {
        log('FCM token is null');
      }
    });

    // In case the token refreshed we save it too to DB
    messaging.onTokenRefresh.listen((value) {
      _sendTokenToSupabase(value);
    });

    // Background/killed status
    FirebaseMessaging.onBackgroundMessage(_handlebackgroundMessage);

    // Foreground
    _handleForegroundMessage();
  }

  static Future<void> _handlebackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log(message.notification?.title ?? 'null');
  }

  static void _handleForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // show local notification
      LocalNotificationService.showBasicNotification(message);
    });
  }

  static void _sendTokenToSupabase(String token) {
    SupabaseAuthService auth = SupabaseAuthService();

    if (auth.currentUser != null) {
      SupabaseDatabaseService supabase = SupabaseDatabaseService();
      supabase
          .from('users')
          .update({'fcm_token': token})
          .eq('id', auth.currentUser!.id)
          .select()
          .then((onValue) {
            // DO NOT REMOVE THIS LINE. IN ORDER TO UPDATE YOU NEED TO USE onValue VARIABLE
            log(
              'Saved fcm_token to supabase of user id ${auth.currentUser!.id} and fcm_token of $token\nReturned Value: $onValue',
            );
          });
    } else {
      log('User not signed in to save his fcm_token to supabase');
    }
  }
}

class TopicSubscriptionManager {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> subscribeToParentTopics(CachedAccount currentAccount) async {
    String schoolId = currentAccount.schoolId.toString();
    String gradeId = currentAccount.ids.gradeId.toString();
    String classId = currentAccount.ids.classId.toString();

    await Future.wait([
      messaging.subscribeToTopic('all'),

      messaging.subscribeToTopic('parent'),

      messaging.subscribeToTopic('school-$schoolId'),
      messaging.subscribeToTopic('school-$schoolId-parent'),

      messaging.subscribeToTopic('grade-$gradeId'),
      messaging.subscribeToTopic('grade-$gradeId-parent'),

      messaging.subscribeToTopic('school-$schoolId-grade-$gradeId'),
      messaging.subscribeToTopic('school-$schoolId-grade-$gradeId-parent'),

      messaging.subscribeToTopic(
        'school-$schoolId-grade-$gradeId-class-$classId',
      ),
      messaging.subscribeToTopic(
        'school-$schoolId-grade-$gradeId-class-$classId-parent',
      ),
    ]);

    log('Subscribet to parent topics');
  }

  Future<void> subscribeToStudentTopics(CachedAccount currentAccount) async {
    String schoolId = currentAccount.schoolId.toString();
    String gradeId = currentAccount.ids.gradeId.toString();
    String classId = currentAccount.ids.classId.toString();

    await Future.wait([
      messaging.subscribeToTopic('all'),

      messaging.subscribeToTopic('student'),

      messaging.subscribeToTopic('school-$schoolId'),
      messaging.subscribeToTopic('school-$schoolId-student'),

      messaging.subscribeToTopic('grade-$gradeId'),
      messaging.subscribeToTopic('grade-$gradeId-student'),

      messaging.subscribeToTopic('school-$schoolId-grade-$gradeId'),
      messaging.subscribeToTopic('school-$schoolId-grade-$gradeId-student'),

      messaging.subscribeToTopic(
        'school-$schoolId-grade-$gradeId-class-$classId',
      ),
      messaging.subscribeToTopic(
        'school-$schoolId-grade-$gradeId-class-$classId-student',
      ),
    ]);

    log('Subscribet to student topics');
  }

  Future<void> subscribeToTeacherTopics(CachedAccount currentAccount) async {
    String schoolId = currentAccount.schoolId.toString();
    String subjectId = currentAccount.ids.subjectId.toString();

    await Future.wait([
      messaging.subscribeToTopic('all'),

      messaging.subscribeToTopic('teacher'),

      messaging.subscribeToTopic('school-$schoolId'),
      messaging.subscribeToTopic('school-$schoolId-teacher'),

      messaging.subscribeToTopic('subject-$subjectId'),
      messaging.subscribeToTopic('subject-$subjectId-teacher'),

      messaging.subscribeToTopic('school-$schoolId-subject-$subjectId'),
      messaging.subscribeToTopic('school-$schoolId-subject-$subjectId-teacher'),
    ]);
    log('Subscribet to teacher topics');
  }

  /// This clears the device's token AND automatically unsubscribes it from ALL topics
  /// Note: the [fcm_token] field in supabase is the same even that user signed out
  Future<void> unSubscribeFromAllTopics() async {
    await FirebaseMessaging.instance.deleteToken();
    log('Unsubscribed from all topics and deleted FCM token');
  }
}

class SendNotification {
  final _supabase = SupabaseEdgeService();

  Future<void> sendByUserId(String userId, String title, String body) async {
    final response = await _supabase.invoke(
      functionName: 'send-fcm',
      body: {'user_id': userId, 'title': title, 'body': body},
    );

    if (response.status != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> sendByTopic(String topic, String title, String body) async {
    final response = await _supabase.invoke(
      functionName: 'send-fcm',
      body: {'topic': topic, 'title': title, 'body': body},
    );

    if (response.status != 200) {
      throw Exception(response.data);
    }
  }
}
