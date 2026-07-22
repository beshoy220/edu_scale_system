class StudentSubjectsBasedOnTimetableModel {
  final int id;
  final String name;

  const StudentSubjectsBasedOnTimetableModel({
    required this.id,
    required this.name,
  });

  factory StudentSubjectsBasedOnTimetableModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentSubjectsBasedOnTimetableModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'StudentSubjectsBasedOnTimetableModel(id: $id, name: $name)';
  }
}
