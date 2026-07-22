class AssignmentStatisticsModel {
  final int totalSubmissions;
  final Map<String, int> submissionsByGrade;
  final int publishedAssignments;
  final int unpublishedAssignments;

  AssignmentStatisticsModel({
    required this.totalSubmissions,
    required this.submissionsByGrade,
    required this.publishedAssignments,
    required this.unpublishedAssignments,
  });

  factory AssignmentStatisticsModel.fromJson(Map<String, dynamic> json) {
    return AssignmentStatisticsModel(
      totalSubmissions: (json['total_submissions'] ?? 0) as int,
      submissionsByGrade:
          (json['submissions_by_grade'] as Map<String, dynamic>? ?? {}).map(
            (key, value) => MapEntry(key, (value as num).toInt()),
          ),
      publishedAssignments: (json['published_assignments'] ?? 0) as int,
      unpublishedAssignments: (json['unpublished_assignments'] ?? 0) as int,
    );
  }

  @override
  String toString() {
    return 'AssignmentStatisticsModel(totalSubmissions: $totalSubmissions, submissionsByGrade: $submissionsByGrade, publishedAssignments: $publishedAssignments, unpublishedAssignments: $unpublishedAssignments)';
  }
}
