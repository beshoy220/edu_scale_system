import 'package:edu_scale/core/progress_manager/models.dart';
import 'package:edu_scale/core/supabase_service/supabase_database_service.dart';

/// ---------------------------------------------------------------------------
/// ProgressManager
/// ---------------------------------------------------------------------------
///
/// Handles all gamification progress for a user.
///
/// Responsibilities:
///
/// • Read user progress.
///
/// • Add points.
///
/// • Register weekly streaks.
///
/// • Check newly earned badges.
///
/// ---------------------------------------------------------------------------
/// Accessibility & Usage of Progress Manager
/// ---------------------------------------------------------------------------
///
/// You can access the Progress Manager across the app by one
/// of the following methods.
///
/// 1. Direct access to ProgressManager() to get the class functionalities like following:
/// ```
/// ProgressManager.getProgressById(userId);
/// ProgressManager.addPoints(userId, 10);
/// ProgressManager.registerStreak(userId);
/// ...etc
/// ```
///
/// 2. Access it with UI widget. the widget itself already access
/// the Progress Manager so no need to manually do it, and jsut call
/// the UI widget like following:
/// ```
///  showModalBottomSheet(
///    context: context,
///    isScrollControlled: true,
///    backgroundColor: Colors.transparent,
///    builder: (_) => WeeklyStreakBottomSheet(
///      currentStreak: progress?.currentStreak,
///      longestStreak: progress?.longestStreak,
///    ),
///  );
///
///  Navigator.push(
///      context,
///        MaterialPageRoute<void>(
///          builder: (BuildContext context) => GainPointsRewardPage(points: 10),
///        ),
///      );
/// ```
///
/// ---------------------------------------------------------------------------
/// Weekly Streak Rules
/// ---------------------------------------------------------------------------
///
/// A streak is counted per CALENDAR WEEK.
///
/// The user only needs to use the app ONCE during a week to
/// keep the streak.
///
/// Example:
///
/// Week 1
///   Monday ✔
///
/// Week 2
///   Sunday ✔
///
/// Week 3
///   Friday ✔
///
/// Current streak = 3
///
/// Missing several days inside a week DOES NOT break the streak.
///
/// A streak only resets if the user skips an ENTIRE calendar week.
///
/// Example:
///
/// Week 1 ✔
/// Week 2 ✔
/// Week 3 ❌
/// Week 4 ✔
///
/// Current streak = 1
///
/// NOTE:
/// The database column "last_streak_week" is used to store the
/// last week that counted toward the streak.
/// It is NOT the user's latest login timestamp.
class ProgressManager {
  /// Returns the gamification progress for a user.
  static Future<UserProgress?> getProgressById(String userId) async {
    final supabaseDB = SupabaseDatabaseService();

    final progressFuture = await supabaseDB
        .from('user_progress')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    final badgesFuture = await supabaseDB
        .from('user_badges')
        .select('''
      earned_at,
      badges(
        id,
        name,
        description,
        icon_url,
        category,
        requirement,
        requirement_value
      )
    ''')
        .eq('user_id', userId);

    if (progressFuture == null) return null;

    // Inject the badges into the JSON so your existing
    // UserProgress.fromJson() can parse them.
    progressFuture['user_badges'] = badgesFuture;

    return UserProgress.fromJson(progressFuture);
  }

  /// Adds points to the user.
  ///
  /// Negative values are allowed but the final value
  /// can never become less than zero.
  static Future<void> addPoints(String userId, int points) async {
    final current = await getProgressById(userId);

    if (current == null) return;

    final newPoints = (current.points + points).clamp(0, 2147483647);

    final supabaseDB = SupabaseDatabaseService();
    await supabaseDB
        .from('user_progress')
        .update({
          'points': newPoints,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);
  }

  /// Registers this week's streak.
  ///
  /// Returns:
  /// - true  -> streak was updated.
  /// - false -> streak was already registered this week.
  static Future<bool> registerStreak(String userId) async {
    final current = await getProgressById(userId);

    if (current == null) return false;

    final currentWeek = _weekStart(DateTime.now());

    // First streak ever
    if (current.lastStreakWeek == null) {
      final supabaseDB = SupabaseDatabaseService();

      await supabaseDB
          .from('user_progress')
          .update({
            'current_streak': 1,
            'longest_streak': current.longestStreak < 1
                ? 1
                : current.longestStreak,
            'last_streak_week': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId);

      return true;
    }

    final previousWeek = _weekStart(current.lastStreakWeek!);

    // Already registered this week
    if (previousWeek == currentWeek) {
      return false;
    }

    final weeksDifference = currentWeek.difference(previousWeek).inDays ~/ 7;

    int newStreak;

    if (weeksDifference == 1) {
      // Consecutive week
      newStreak = current.currentStreak + 1;
    } else {
      // Missed one or more weeks
      newStreak = 1;
    }

    final longest = newStreak > current.longestStreak
        ? newStreak
        : current.longestStreak;

    final supabaseDB = SupabaseDatabaseService();

    await supabaseDB
        .from('user_progress')
        .update({
          'current_streak': newStreak,
          'longest_streak': longest,
          'last_streak_week': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);

    return true;
  }

  /// Returns true if the streak has already been
  /// counted during the current week.
  static Future<bool> isStreakUpdatedThisWeek(String userId) async {
    final progress = await getProgressById(userId);

    if (progress!.lastStreakWeek == null) {
      return false;
    }

    return _weekStart(progress.lastStreakWeek!) == _weekStart(DateTime.now());
  }

  /// Returns the Saterday representing the week of [date].
  ///
  /// Every day inside the same calendar week returns
  /// the exact same DateTime.
  static DateTime _weekStart(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);

    final daysSinceSaturday = (normalized.weekday + 1) % 7;

    return normalized.subtract(Duration(days: daysSinceSaturday));
  }

  /// Executes the reward RPC and returns all badges
  /// unlocked during this operation. returns [] if no bageds accuried.
  static Future<List<BadgeReward>> checkBadgeReward(String userId) async {
    final supabaseDB = SupabaseDatabaseService();
    final data = await supabaseDB.rpc(
      'check_reward_badges',
      params: {'p_user_id': userId},
    );

    // debugPrint(data.toString());

    return (data as List)
        .map((e) => BadgeReward.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
