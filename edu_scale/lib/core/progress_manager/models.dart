class UserBadge {
  UserBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.category,
    required this.requirement,
    required this.requirementValue,
    required this.earnedAt,
  });

  final int id;
  final String name;
  final String description;
  final String iconUrl;
  final String category;
  final String requirement;
  final int requirementValue;
  final DateTime earnedAt;

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    final badge = json['badges'] as Map<String, dynamic>;

    return UserBadge(
      id: badge['id'] as int,
      name: badge['name'] as String,
      description: badge['description'] as String,
      iconUrl: badge['icon_url'] as String,
      category: badge['category'] as String,
      requirement: badge['requirement'] as String,
      requirementValue: badge['requirement_value'] as int,
      earnedAt: DateTime.parse(json['earned_at'] as String),
    );
  }

  @override
  String toString() =>
      'UserBadge(id: $id, name: $name, earnedAt: $earnedAt...)';
}

class UserProgress {
  UserProgress({
    required this.userId,
    required this.points,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastStreakWeek,
    required this.badges,
  });

  final String userId;
  int points;
  int currentStreak;
  int longestStreak;
  DateTime? lastStreakWeek;

  /// All badges earned by the user.
  final List<UserBadge> badges;

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['user_id'] as String,
      points: json['points'] as int,
      currentStreak: json['current_streak'] as int,
      longestStreak: json['longest_streak'] as int,
      lastStreakWeek: json['last_streak_week'] == null
          ? null
          : DateTime.parse(json['last_streak_week'] as String),
      badges: (json['user_badges'] as List<dynamic>? ?? [])
          .map((e) => UserBadge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() =>
      'UserProgress(userId: $userId, points: $points, currentStreak: $currentStreak, longestStreak: $longestStreak, lastStreakWeek: $lastStreakWeek, badges: $badges)';
}

class BadgeReward {
  BadgeReward({
    required this.badgeId,
    required this.badgeName,
    required this.badgeIconUrl,
  });

  final int badgeId;
  final String badgeName;
  final String badgeIconUrl;

  factory BadgeReward.fromJson(Map<String, dynamic> json) {
    return BadgeReward(
      badgeId: json['out_badge_id'] as int,
      badgeName: json['out_badge_name'] as String,
      badgeIconUrl: json['out_badge_icon_url'] as String,
    );
  }

  @override
  String toString() =>
      'BadgeReward(badgeId: $badgeId, badgeName: $badgeName, badgeIconUrl: $badgeIconUrl)';
}
