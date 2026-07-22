class LibraryItemModel {
  final int id;
  final String title;
  final String fileUrl;
  final int fileSizeInKb;
  final String fileType;
  final String status;
  final DateTime createdAt;
  final String subjectName;
  final String gradeName;
  final String? classNickname;
  final String uploadedBy;

  LibraryItemModel({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.fileSizeInKb,
    required this.fileType,
    required this.status,
    required this.createdAt,
    required this.subjectName,
    required this.gradeName,
    required this.classNickname,
    required this.uploadedBy,
  });

  factory LibraryItemModel.fromJson(Map<String, dynamic> json) {
    return LibraryItemModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      fileUrl: json['file_url'] ?? '',
      fileSizeInKb: json['file_size_in_kb'] ?? 0,
      fileType: (json['file_type'] ?? '').toString().trim(),
      status: (json['status'] ?? '').toString().trim(),
      createdAt: DateTime.parse(json['created_at']),
      subjectName: json['subjects']?['name'] ?? '',
      gradeName: json['grades']?['name'] ?? '',
      classNickname: (json['classes'] == null)
          ? 'Whole grade'
          : json['classes']?['nickname'],
      uploadedBy: json['users']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'file_url': fileUrl,
      'file_size_in_kb': fileSizeInKb,
      'file_type': fileType,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'subject_name': subjectName,
      'grade_name': gradeName,
      'class_name': classNickname,
      'uploaded_by': uploadedBy,
    };
  }

  static List<LibraryItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LibraryItemModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<LibraryItemModel> models) {
    return models.map((e) => e.toJson()).toList();
  }
}
