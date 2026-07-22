class QuizStatisticsModel {
  final int totalSubmissions;
  final Map<String, int> submissionsByGrade;
  final int publishedQuizzes;
  final int unpublishedQuizzes;

  QuizStatisticsModel({
    required this.totalSubmissions,
    required this.submissionsByGrade,
    required this.publishedQuizzes,
    required this.unpublishedQuizzes,
  });

  factory QuizStatisticsModel.fromJson(Map<String, dynamic> json) {
    return QuizStatisticsModel(
      totalSubmissions: (json['total_submissions'] ?? 0) as int,
      submissionsByGrade:
          (json['submissions_by_grade'] as Map<String, dynamic>? ?? {}).map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          ),
      publishedQuizzes: (json['published_quizzes'] ?? 0) as int,
      unpublishedQuizzes: (json['unpublished_quizzes'] ?? 0) as int,
    );
  }

  @override
  String toString() {
    return 'QuizStatisticsModel(totalSubmissions: $totalSubmissions, submissionsByGrade: $submissionsByGrade, publishedQuizzes: $publishedQuizzes, unpublishedQuizzes: $unpublishedQuizzes)';
  }
}
