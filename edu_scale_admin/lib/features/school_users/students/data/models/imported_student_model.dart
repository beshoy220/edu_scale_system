class ImportedStudent {
  final String studentName;
  final String parentName;
  final String parentPhone;
  final String grade;
  final String studentClass;

  ImportedStudent({
    required this.studentName,
    required this.parentName,
    required this.parentPhone,
    required this.grade,
    required this.studentClass,
  });

  factory ImportedStudent.fromMap(Map<String, dynamic> map) {
    return ImportedStudent(
      studentName: map['Student Name'] ?? '',
      parentName: map['Parent Name'] ?? '',
      parentPhone: map['Parent Phone'] ?? '',
      grade: map['Grade'] ?? '',
      studentClass: map['Class'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ImportedStudent(studentName: $studentName, parentName: $parentName, parentPhone: $parentPhone, grade: $grade, studentClass: $studentClass)';
  }
}

class StudentProblem {
  final ImportedStudent student;
  final String problem;

  StudentProblem({required this.student, required this.problem});
}
