class AttendanceStatisticsModel {
  final OverallStats overall;
  final Map<String, DayStats> byDay;
  final Map<String, GradeStats> byGrade;

  AttendanceStatisticsModel({
    required this.overall,
    required this.byDay,
    required this.byGrade,
  });

  factory AttendanceStatisticsModel.fromJson(Map<String, dynamic> json) {
    // Overall
    final overallJson = json['overall'] as Map<String, dynamic>? ?? {};
    final overall = OverallStats(
      presentPercentage: (overallJson['present_percentage'] ?? 0).toDouble(),
      absentPercentage: (overallJson['absent_percentage'] ?? 0).toDouble(),
      latePercentage: (overallJson['late_percentage'] ?? 0).toDouble(),
      excusedPercentage: (overallJson['excused_percentage'] ?? 0).toDouble(),
    );

    // By day
    final byDayJson = json['by_day'] as Map<String, dynamic>? ?? {};
    final byDay = <String, DayStats>{};
    byDayJson.forEach((day, stats) {
      final statsMap = stats as Map<String, dynamic>;
      byDay[day] = DayStats(
        present: (statsMap['present'] ?? 0) as int,
        absent: (statsMap['absent'] ?? 0) as int,
        late: (statsMap['late'] ?? 0) as int,
        excused: (statsMap['excused'] ?? 0) as int,
      );
    });

    // By grade
    final byGradeJson = json['by_grade'] as Map<String, dynamic>? ?? {};
    final byGrade = <String, GradeStats>{};
    byGradeJson.forEach((grade, stats) {
      final statsMap = stats as Map<String, dynamic>;
      byGrade[grade] = GradeStats(
        present: (statsMap['present'] ?? 0) as int,
        absent: (statsMap['absent'] ?? 0) as int,
        late: (statsMap['late'] ?? 0) as int,
        excused: (statsMap['excused'] ?? 0) as int,
      );
    });

    return AttendanceStatisticsModel(
      overall: overall,
      byDay: byDay,
      byGrade: byGrade,
    );
  }

  @override
  String toString() {
    return 'AttendanceStatisticsModel(overall: $overall, byDay: $byDay, byGrade: $byGrade)';
  }
}

class OverallStats {
  final double presentPercentage;
  final double absentPercentage;
  final double latePercentage;
  final double excusedPercentage;

  OverallStats({
    required this.presentPercentage,
    required this.absentPercentage,
    required this.latePercentage,
    required this.excusedPercentage,
  });

  @override
  String toString() {
    return 'OverallStats(presentPercentage: $presentPercentage, absentPercentage: $absentPercentage, latePercentage: $latePercentage, excusedPercentage: $excusedPercentage)';
  }
}

class DayStats {
  final int present;
  final int absent;
  final int late;
  final int excused;

  DayStats({
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
  });

  @override
  String toString() {
    return 'DayStats(present: $present, absent: $absent, late: $late, excused: $excused)';
  }
}

class GradeStats {
  final int present;
  final int absent;
  final int late;
  final int excused;

  GradeStats({
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
  });

  @override
  String toString() {
    return 'GradeStats(present: $present, absent: $absent, late: $late, excused: $excused)';
  }
}
