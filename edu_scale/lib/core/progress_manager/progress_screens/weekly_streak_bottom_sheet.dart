import 'package:edu_scale/core/themes/themes.dart';
import 'package:flutter/material.dart';

/// Example:
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => WeeklyStreakBottomSheet(
///     currentStreak: 3,
///     longestStreak: 3,
///   ),
/// );

class WeeklyStreakBottomSheet extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  const WeeklyStreakBottomSheet({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
  });

  static const List<int> _milestones = [1, 5, 10, 20, 50, 100];

  @override
  Widget build(BuildContext context) {
    final nextMilestone = _milestones.firstWhere(
      (m) => currentStreak < m,
      orElse: () => currentStreak + 10,
    );

    final progress = (currentStreak / nextMilestone).clamp(0.0, 1.0);

    return Container(
      height: AppStyle.deviceSize.currentDeviceSize(context).height * 0.9,
      decoration: BoxDecoration(
        color: AppStyle.colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Handle
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppStyle.colors.grey,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),

                const SizedBox(height: 24),

                Icon(
                  Icons.local_fire_department_rounded,
                  size: 70,
                  color: AppStyle.colors.orange,
                ),

                const SizedBox(height: 14),

                Text(
                  'You\'re On Fire!',
                  style: TextStyle(
                    color: AppStyle.colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  '$currentStreak Week Streak',
                  style: TextStyle(
                    color: AppStyle.colors.orange,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  _message(currentStreak),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppStyle.colors.black, fontSize: 15),
                ),

                const SizedBox(height: 30),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Week Journey',
                    style: TextStyle(
                      color: AppStyle.colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                _WeekJourney(currentStreak),

                const SizedBox(height: 28),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${nextMilestone - currentStreak} more week${nextMilestone - currentStreak == 1 ? '' : 's'} until $nextMilestone weeks!',
                    style: TextStyle(color: AppStyle.colors.black),
                  ),
                ),

                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: AppStyle.colors.grey,
                    valueColor: AlwaysStoppedAnimation(AppStyle.colors.orange),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.local_fire_department,
                        title: 'Current',
                        value: '$currentStreak',
                        color: AppStyle.colors.orange,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _StatCard(
                        icon: Icons.emoji_events,
                        title: 'Best',
                        value: '$longestStreak',
                        color: AppStyle.colors.yellow,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.colors.orange,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(18),
                      // ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Continue Learning',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _message(int streak) {
    if (streak == 0) {
      return 'Start your first learning streak today!';
    }

    if (streak == 1) {
      return 'Great start! Keep the flame burning.';
    }

    if (streak < 5) {
      return 'You\'re building an amazing learning habit.';
    }

    if (streak < 10) {
      return 'Fantastic consistency! Keep going.';
    }

    if (streak < 20) {
      return 'Your dedication is inspiring!';
    }

    return 'Legendary learner! Don\'t stop now!';
  }
}

class _WeekJourney extends StatelessWidget {
  final int streak;

  const _WeekJourney(this.streak);

  @override
  Widget build(BuildContext context) {
    final visibleWeeks = 5;

    return Row(
      children: List.generate(visibleWeeks, (index) {
        final completed = index < streak;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index != 0)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: completed
                            ? AppStyle.colors.orange
                            : AppStyle.colors.black.withAlpha(100),
                      ),
                    ),
                  Icon(
                    completed
                        ? Icons.local_fire_department
                        : Icons.radio_button_unchecked,
                    color: completed
                        ? AppStyle.colors.orange
                        : AppStyle.colors.black.withAlpha(100),
                  ),
                  if (index != visibleWeeks - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index < streak - 1
                            ? AppStyle.colors.orange
                            : AppStyle.colors.black.withAlpha(100),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                'W${index + 1}',
                style: TextStyle(color: AppStyle.colors.black),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppStyle.colors.grey,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              color: AppStyle.colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 4),

          Text(title, style: TextStyle(color: AppStyle.colors.black)),
        ],
      ),
    );
  }
}
