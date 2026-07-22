class TeacherLibraryResourcesItemModel {
  final int id;

  final int schoolId;
  final String teacherId;

  final int subjectId;
  final int gradeId;
  final int? classId;

  final String title;

  /// Storage path (recommended) or public URL if you keep it that way.
  final String fileUrl;

  final int fileSizeInKb;

  /// allowed extensions: pdf, doc, docx, xls, xlsx, ppt, pptx, png, jpg
  final String fileType;

  /// approved, pendding, rejected
  final String status;

  final DateTime createdAt;

  const TeacherLibraryResourcesItemModel({
    required this.id,
    required this.schoolId,
    required this.teacherId,
    required this.subjectId,
    required this.gradeId,
    this.classId,
    required this.title,
    required this.fileUrl,
    required this.fileSizeInKb,
    required this.fileType,
    required this.status,
    required this.createdAt,
  });

  factory TeacherLibraryResourcesItemModel.fromJson(Map<String, dynamic> json) {
    return TeacherLibraryResourcesItemModel(
      id: json['id'] as int,
      schoolId: json['school_id'] as int,
      teacherId: json['teacher_id'] as String,
      subjectId: json['subject_id'] as int,
      gradeId: json['grade_id'] as int,
      classId: json['class_id'] as int?,
      title: json['title'] as String,
      fileUrl: json['file_url'] as String,
      fileSizeInKb: json['file_size_in_kb'] as int,
      fileType: json['file_type'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'teacher_id': teacherId,
      'subject_id': subjectId,
      'grade_id': gradeId,
      'class_id': classId,
      'title': title,
      'file_url': fileUrl,
      'file_size_in_kb': fileSizeInKb,
      'file_type': fileType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  TeacherLibraryResourcesItemModel copyWith({
    int? id,
    int? schoolId,
    String? teacherId,
    int? subjectId,
    int? gradeId,
    int? classId,
    String? title,
    String? fileUrl,
    int? fileSizeInKb,
    String? fileType,
    String? status,
    DateTime? createdAt,
  }) {
    return TeacherLibraryResourcesItemModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      teacherId: teacherId ?? this.teacherId,
      subjectId: subjectId ?? this.subjectId,
      gradeId: gradeId ?? this.gradeId,
      classId: classId ?? this.classId,
      title: title ?? this.title,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSizeInKb: fileSizeInKb ?? this.fileSizeInKb,
      fileType: fileType ?? this.fileType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
