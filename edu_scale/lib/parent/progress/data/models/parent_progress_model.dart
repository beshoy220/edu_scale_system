class ParentProgressModel {
  final String userId;
  final int points;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastStreakWeek;
  final DateTime updatedAt;
  final DateTime createdAt;
  final List<UserBadge> userBadges;

  const ParentProgressModel({
    required this.userId,
    required this.points,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastStreakWeek,
    required this.updatedAt,
    required this.createdAt,
    required this.userBadges,
  });

  factory ParentProgressModel.fromJson(Map<String, dynamic> json) {
    return ParentProgressModel(
      userId: json['user_id'] as String,
      points: json['points'] as int,
      currentStreak: json['current_streak'] as int,
      longestStreak: json['longest_streak'] as int,
      lastStreakWeek: json['last_streak_week'] != null
          ? DateTime.parse(json['last_streak_week'])
          : null,
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
      userBadges: (json['user_badges'] as List<dynamic>? ?? [])
          .map((e) => UserBadge.fromJson(e))
          .toList(),
    );
  }
}

class UserBadge {
  final DateTime earnedAt;
  final Badge badge;

  const UserBadge({required this.earnedAt, required this.badge});

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      earnedAt: DateTime.parse(json['earned_at']),
      badge: Badge.fromJson(json['badges']),
    );
  }
}

class Badge {
  final int id;
  final String name;
  final String description;
  final String? iconUrl;
  final String category;
  final String requirement;
  final int requirementValue;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    this.iconUrl,
    required this.category,
    required this.requirement,
    required this.requirementValue,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      category: json['category'] as String,
      requirement: json['requirement'] as String,
      requirementValue: json['requirement_value'] as int,
    );
  }
}
