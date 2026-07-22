class CompetitionStatisticsModel {
  final int totalCompetitionsSubmitted;
  final Map<String, int> submissionsPerGrade;
  final int soloCompetitionsCount;
  final int teamCompetitionsCount;

  CompetitionStatisticsModel({
    required this.totalCompetitionsSubmitted,
    required this.submissionsPerGrade,
    required this.soloCompetitionsCount,
    required this.teamCompetitionsCount,
  });

  factory CompetitionStatisticsModel.fromJson(Map<String, dynamic> json) {
    return CompetitionStatisticsModel(
      totalCompetitionsSubmitted:
          (json['total_competitions_submitted'] ?? 0) as int,

      submissionsPerGrade:
          (json['submissions_per_grade'] as Map<String, dynamic>? ?? {}).map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          ),

      soloCompetitionsCount: (json['solo_competitions_count'] ?? 0) as int,

      teamCompetitionsCount: (json['team_competitions_count'] ?? 0) as int,
    );
  }

  @override
  String toString() {
    return 'CompetitionStatisticsModel(totalCompetitionsSubmitted: $totalCompetitionsSubmitted, submissionsPerGrade: $submissionsPerGrade, soloCompetitionsCount: $soloCompetitionsCount, teamCompetitionsCount: $teamCompetitionsCount)';
  }
}
